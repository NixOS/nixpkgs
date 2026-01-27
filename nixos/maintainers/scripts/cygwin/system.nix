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
    coreutils
    runCommand
    writeShellScript
    cygwin
    ;

  nix = config.nix.package;

  sw = buildEnv {
    name = "cygwin-root";

    paths = config.environment.systemPackages;

    nativeBuildInputs = [
      ../../../../pkgs/build-support/setup-hooks/make-symlinks-relative.sh
    ];
  };

  activate = writeShellScript "activate" ''
    (
      export PATH=${
        lib.makeBinPath [
          coreutils
          nix
        ]
      }:/bin
      mkdir -p /nix/var/nix/gcroots
      ln -sfn /run/current-system /nix/var/nix/gcroots/current-system
      mkdir -p /run
      ln -sfn '${lib.getExe bash}' /bin/sh
      ln -sfn '@out@' /run/current-system
      ln -sfn /run/current-system/etc /etc
      if [[ -f /nix-path-registration ]]; then
        nix-store --load-db < /nix-path-registration
        rm -f /nix-path-registration
      fi
    )
  '';

  cygwin1 = cygwin.newlib-cygwin.out + "/bin/cygwin1.dll";

in
{
  options = {
    system.cygwin.toplevel = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
  };

  imports = [
    ./profile.nix
  ];

  config = {
    system.cygwin.toplevel = runCommand "cygwin-system" { } ''
      mkdir "$out"
      ln -sr "${sw}" "$out"/sw
      ln -sr "${cygwin1}" "$out"/
      cp "${activate}" "$out"/activate
      substituteInPlace $out/activate --subst-var-by out "$out"
      ln -sr "${config.system.build.etc}"/etc $out/etc
    '';
  };
}
