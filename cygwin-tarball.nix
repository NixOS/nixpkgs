{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (pkgs)
    bash
    buildEnv
    buildPackages
    cacert
    coreutils
    cygwin
    lib
    nix
    openssh
    runCommand
    writeShellScript
    writeText
    ;

  sw = buildEnv {
    name = "cygwin-root";

    paths = [
      bash
      coreutils
      nix
      openssh
    ];

    nativeBuildInputs = [
      ./pkgs/build-support/setup-hooks/make-symlinks-relative.sh
    ];
  };

  cmd = writeText "cygwin.cmd" (
    lib.replaceString "\n" "\r\n" ''
      @echo off
      set PATH=%~dp0\bin;%PATH%
      set BASH="%~dp0${lib.replaceString "/" "\\" (lib.getBin bash).outPath}\bin\bash.exe"
      %BASH% /nix/var/nix/profiles/system/activate || exit /b
      %BASH% --login -i || exit /b
    ''
  );

  activate = writeShellScript "activate" ''
    (
      export PATH=${
        lib.makeBinPath [
          coreutils
          nix
        ]
      }:/bin
      mkdir -p /run
      ln -sfn '${lib.getExe bash}' /bin/sh
      ln -sfn '@out@' /run/current-system
      ln -sfn /run/current-system/etc /etc
      if [[ -f /nix-path-registration ]]; then
        nix-store --load-db < /nix-path-registration
        rm /nix-path-registration
      fi
    )
  '';

in
{
  options.system.build.tarball = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
  };

  config = {
    environment.etc."profile".text = ''
      export PATH=/run/current-system/sw/bin:/bin:$PATH
    '';

    system.build = {
      toplevel = runCommand "cygwin-system" { } ''
        mkdir "$out"
        ln -sr "${sw}" "$out"/sw
        cp "${activate}" "$out"/activate
        substituteInPlace $out/activate --subst-var-by out "$out"
        ln -sr "${config.system.build.etc}"/etc $out/etc
      '';

      tarball =
        let
          system = config.system.build.toplevel;
        in
        (pkgs.callPackage nixos/lib/make-system-tarball.nix {
          # HACK: disable compression
          compressCommand = "cat";
          compressionExtension = "";

          contents = [
            {
              source = lib.getBin cygwin.newlib-cygwin + "/bin/cygwin1.dll";
              target = "/bin/cygwin1.dll";
            }
            {
              source = cmd;
              target = "cygwin.cmd";
            }
          ];

          storeContents = [
            {
              object = system;
              symlink = "none";
            }
          ];

          extraCommands = buildPackages.writeShellScript "extra-commands.sh" ''
            chmod -R +w nix
            mkdir -p tmp nix/var/nix/profiles
            ln -s "$(realpath -s --relative-to=/nix/var/nix/profiles "${system}")" nix/var/nix/profiles/system
            find . -type l -print0 | while read -r -d "" f; do
                symlinkTarget=$(readlink "$f")
                if [[ "$symlinkTarget"/ != /nix/store* ]]; then
                    # skip this symlink as it doesn't point to /nix/store
                    continue
                fi

                symlinkTarget=''${symlinkTarget#/}

                if [ ! -e "$symlinkTarget" ]; then
                    echo "the symlink $f is broken, it points to $symlinkTarget (which is missing)"
                fi

                echo "rewriting symlink $f to be relative to /nix/store"
                ln -snrf "$symlinkTarget" "$f"
            done
          '';
        })
        // {
          inherit system;
        };
    };
  };
}
