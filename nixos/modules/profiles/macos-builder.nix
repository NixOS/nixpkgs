{ config, lib, options, ... }:

let
  keysDirectory = "/var/keys";

  user = "builder";

  keyType = "ed25519";

  cfg = config.virtualisation.darwin-builder;

in

{
  imports = [
    ../virtualisation/qemu-vm.nix

    # Avoid a dependency on stateVersion
    {
      disabledModules = [
        ../virtualisation/nixos-containers.nix
        ../services/x11/desktop-managers/xterm.nix
      ];
      # swraid's default depends on stateVersion
      config.boot.swraid.enable = false;
      options.boot.isContainer = lib.mkOption { default = false; internal = true; };
    }
  ];

  options.virtualisation.darwin-builder = with lib; {
    diskSize = mkOption {
      default = 20 * 1024;
      type = types.int;
      example = 30720;
      description = "The maximum disk space allocated to the runner in MB";
    };
    memorySize = mkOption {
      default = 3 * 1024;
      type = types.int;
      example = 8192;
      description = "The runner's memory in MB";
    };
    min-free = mkOption {
      default = 1024 * 1024 * 1024;
      type = types.int;
      example = 1073741824;
      description = ''
        The threshold (in bytes) of free disk space left at which to
        start garbage collection on the runner
      '';
    };
    max-free = mkOption {
      default = 3 * 1024 * 1024 * 1024;
      type = types.int;
      example = 3221225472;
      description = ''
        The threshold (in bytes) of free disk space left at which to
        stop garbage collection on the runner
      '';
    };
    workingDirectory = mkOption {
       default = ".";
       type = types.str;
       example = "/var/lib/darwin-builder";
       description = ''
         The working directory to use to run the script. When running
         as part of a flake will need to be set to a non read-only filesystem.
       '';
    };
    hostPort = mkOption {
      default = 31022;
      type = types.int;
      example = 22;
      description = ''
        The localhost host port to forward TCP to the guest port.
      '';
    };
  };

  config = {
    # The builder is not intended to be used interactively
    documentation.enable = false;

    environment.etc = {
      "ssh/ssh_host_ed25519_key" = {
        mode = "0600";

        source = ./keys/ssh_host_ed25519_key;
      };

      "ssh/ssh_host_ed25519_key.pub" = {
        mode = "0644";

        source = ./keys/ssh_host_ed25519_key.pub;
      };
    };

    # DNS fails for QEMU user networking (SLiRP) on macOS.  See:
    #
    # https://github.com/utmapp/UTM/issues/2353
    #
    # This works around that by using a public DNS server other than the DNS
    # server that QEMU provides (normally 10.0.2.3)
    networking.nameservers = [ "8.8.8.8" ];

    # The linux builder is a lightweight VM for remote building; not evaluation.
    nix.channel.enable = false;
    # remote builder uses `nix-daemon` (ssh-ng:) or `nix-store --serve` (ssh:)
    # --force: do not complain when missing
    # TODO: install a store-only nix
    #       https://github.com/NixOS/rfcs/blob/master/rfcs/0134-nix-store-layer.md#detailed-design
    environment.extraSetup = ''
      rm --force $out/bin/{nix-instantiate,nix-build,nix-shell,nix-prefetch*,nix}
    '';
    # Deployment is by image.
    # TODO system.switch.enable = false;?
    system.disableInstallerTools = true;

    nix.settings = {
      auto-optimise-store = true;

      min-free = cfg.min-free;

      max-free = cfg.max-free;

      trusted-users = [ "root" user ];
    };

    services = {
      getty.autologinUser = user;

      openssh = {
        enable = true;

        authorizedKeysFiles = [ "${keysDirectory}/%u_${keyType}.pub" ];
      };
    };

    system.build.macos-builder-installer =
      let
        privateKey = "/etc/nix/${user}_${keyType}";

        publicKey = "${privateKey}.pub";

        # This installCredentials script is written so that it's as easy as
        # possible for a user to audit before confirming the `sudo`
        installCredentials = hostPkgs.writeShellScript "install-credentials" ''
          KEYS="''${1}"
          INSTALL=${hostPkgs.coreutils}/bin/install
          "''${INSTALL}" -g nixbld -m 600 "''${KEYS}/${user}_${keyType}" ${privateKey}
          "''${INSTALL}" -g nixbld -m 644 "''${KEYS}/${user}_${keyType}.pub" ${publicKey}
        '';

        hostPkgs = config.virtualisation.host.pkgs;

        script = hostPkgs.writeShellScriptBin "create-builder" (
          # When running as non-interactively as part of a DarwinConfiguration the working directory
          # must be set to a writeable directory.
        (if cfg.workingDirectory != "." then ''
          ${hostPkgs.coreutils}/bin/mkdir --parent "${cfg.workingDirectory}"
          cd "${cfg.workingDirectory}"
        '' else "") + ''
          KEYS="''${KEYS:-./keys}"
          ${hostPkgs.coreutils}/bin/mkdir --parent "''${KEYS}"
          PRIVATE_KEY="''${KEYS}/${user}_${keyType}"
          PUBLIC_KEY="''${PRIVATE_KEY}.pub"
          if [ ! -e "''${PRIVATE_KEY}" ] || [ ! -e "''${PUBLIC_KEY}" ]; then
              ${hostPkgs.coreutils}/bin/rm --force -- "''${PRIVATE_KEY}" "''${PUBLIC_KEY}"
              ${hostPkgs.openssh}/bin/ssh-keygen -q -f "''${PRIVATE_KEY}" -t ${keyType} -N "" -C 'builder@localhost'
          fi
          if ! ${hostPkgs.diffutils}/bin/cmp "''${PUBLIC_KEY}" ${publicKey}; then
            (set -x; sudo --reset-timestamp ${installCredentials} "''${KEYS}")
          fi
          KEYS="$(${hostPkgs.nix}/bin/nix-store --add "$KEYS")" ${lib.getExe config.system.build.vm}
        '');

      in
      script.overrideAttrs (old: {
        pos = __curPos; # sets meta.position to point here; see script binding above for package definition
        meta = (old.meta or { }) // {
          platforms = lib.platforms.darwin;
        };
        passthru = (old.passthru or { }) // {
          # Let users in the repl inspect the config
          nixosConfig = config;
          nixosOptions = options;
        };
      });

    system = {
      # To prevent gratuitous rebuilds on each change to Nixpkgs
      nixos.revision = null;

      stateVersion = lib.mkDefault (throw ''
        The macOS linux builder should not need a stateVersion to be set, but a module
        has accessed stateVersion nonetheless.
        Please inspect the trace of the following command to figure out which module
        has a dependency on stateVersion.

          nix-instantiate --attr darwin.linux-builder --show-trace
      '');
    };

    users.users."${user}" = {
      isNormalUser = true;
    };

    security.polkit.enable = true;

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id === "org.freedesktop.login1.power-off" && subject.user === "${user}") {
          return "yes";
        } else {
          return "no";
        }
      })
    '';

    virtualisation = {
      diskSize = cfg.diskSize;

      memorySize = cfg.memorySize;

      forwardPorts = [
        { from = "host"; guest.port = 22; host.port = cfg.hostPort; }
      ];

      # Disable graphics for the builder since users will likely want to run it
      # non-interactively in the background.
      graphics = false;

      sharedDirectories.keys = {
        source = "\"$KEYS\"";
        target = keysDirectory;
      };

      # If we don't enable this option then the host will fail to delegate builds
      # to the guest, because:
      #
      # - The host will lock the path to build
      # - The host will delegate the build to the guest
      # - The guest will attempt to lock the same path and fail because
      #   the lockfile on the host is visible on the guest
      #
      # Snapshotting the host's /nix/store as an image isolates the guest VM's
      # /nix/store from the host's /nix/store, preventing this problem.
      useNixStoreImage = true;

      # Obviously the /nix/store needs to be writable on the guest in order for it
      # to perform builds.
      writableStore = true;

      # This ensures that anything built on the guest isn't lost when the guest is
      # restarted.
      writableStoreUseTmpfs = false;

      # Pass certificates from host to the guest otherwise when custom CA certificates
      # are required we can't use the cached builder.
      useHostCerts = true;
    };
  };
}
