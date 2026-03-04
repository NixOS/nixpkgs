{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs) writeScript;

  pkgs2storeContents = map (x: {
    object = x;
    symlink = "none";
  });
in

{
  # Docker image config.
  imports = [
    ../installer/cd-dvd/channel.nix
    ./minimal.nix
    ./clone-config.nix
  ];

  # Create the tarball
  system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
    contents = [
      {
        source = "${config.system.build.toplevel}/.";
        target = "./";
      }
    ];
    extraArgs = "--owner=0";

    # Add init script to image
    storeContents = pkgs2storeContents [
      config.system.build.toplevel
      pkgs.stdenv
    ];

    # Some container managers like lxc need these
    extraCommands =
      let
        script = writeScript "extra-commands.sh" ''
          rm etc
          mkdir -p proc sys dev etc
        '';
      in
      script;
  };

  boot.isContainer = true;
  systemd.services.register-nix-paths = {
    description = "Register Nix Store Paths";
    unitConfig = {
      DefaultDependencies = false;
      ConditionPathExists = "/nix-path-registration";
    };
    wantedBy = [ "sysinit.target" ];
    before = [
      "sysinit.target"
      "shutdown.target"
      "nix-daemon.socket"
      "nix-daemon.service"
    ];
    after = [ "local-fs.target" ];
    conflicts = [ "shutdown.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${lib.getExe' config.nix.package.out "nix-store"} --load-db < /nix-path-registration
      rm /nix-path-registration

      # nixos-rebuild also requires a "system" profile
      ${lib.getExe' config.nix.package.out "nix-env"} -p /nix/var/nix/profiles/system --set /run/current-system
    '';
  };

  # Install new init script
  system.activationScripts.installInitScript = ''
    ln -fs $systemConfig/init /init
  '';
}
