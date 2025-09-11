let
  nixpkgs = (import ./. { });

  inherit (nixpkgs.pkgsCross.x86_64-cygwin)
    bash
    buildEnv
    buildPackages
    cacert
    coreutils
    lib
    nix
    runCommand
    writeShellScript
    writeText
    cygwin
    ;

  sw = buildEnv {
    name = "cygwin-root";

    paths = [
      bash
      coreutils
      nix
    ];

    nativeBuildInputs = [
      ./pkgs/build-support/setup-hooks/make-symlinks-relative.sh
    ];

    postBuild = ''
      find $out -type l -print0 | while read -r -d "" f; do
          local symlinkTarget
          symlinkTarget=$(readlink "$f")
          if [[ "$symlinkTarget"/ != /nix/store* ]]; then
              # skip this symlink as it doesn't point to /nix/store
              continue
          fi

          if [ ! -e "$symlinkTarget" ]; then
              echo "the symlink $f is broken, it points to $symlinkTarget (which is missing)"
          fi

          echo "rewriting symlink $f to be relative to /nix/store"
          ln -snrf "$symlinkTarget" "$f"
      done
    '';
  };

  system = runCommand "cygwin-system" { } ''
    mkdir "$out"
    ln -sr "${sw}" "$out"/sw
    ln -sr "${activate}" "$out"/activate
  '';

  cmd = writeText "cygwin.cmd" (
    lib.replaceString "\n" "\r\n" ''
      @echo off
      set PATH=%~dp0\bin;%PATH%
      set BASH="%~dp0${lib.replaceString "/" "\\" (lib.getBin bash).outPath}\bin\bash.exe"
      %BASH% /nix/var/nix/profiles/system/activate || exit /b
      %BASH% --login -i || exit /b
    ''
  );

  profile = writeText "profile" ''
    export PATH="${lib.getBin sw}"/bin:$PATH
  '';

  activate = writeShellScript "activate" ''
    (
      export PATH=${
        lib.makeBinPath [
          coreutils
          nix
        ]
      }:/bin
      rm -rf /etc
      mkdir -p /etc/ssl/certs
      ln -fsr "${cacert}"/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
      ln -fsr "${cacert}"/etc/ssl/trust-source /etc/ssl/
      ln -fsr "${profile}" /etc/profile
      if [[ -f /nix-path-registration ]]; then
        nix-store --load-db < /nix-path-registration
        rm /nix-path-registration
      fi
    )
  '';

in
(nixpkgs.callPackage nixos/lib/make-system-tarball.nix {
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
    mkdir -p tmp nix/var/nix/profiles
    ln -s "$(realpath -s --relative-to=/nix/var/nix/profiles "${system}")" nix/var/nix/profiles/system
  '';
})
// {
  inherit system;
}
