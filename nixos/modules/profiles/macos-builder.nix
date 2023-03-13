{ config, lib, pkgs, ... }:

let
  keysDirectory = "/var/keys";

  user = "builder";

  keyType = "ed25519";

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
      config = { };
      options.boot.isContainer = lib.mkOption { default = false; internal = true; };
    }
  ];

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

  nix.settings = {
    auto-optimise-store = true;

    min-free = 1024 * 1024 * 1024;

    max-free = 3 * 1024 * 1024 * 1024;

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

      script = hostPkgs.writeShellScriptBin "create-builder" ''
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
        KEYS="$(nix-store --add "$KEYS")" ${config.system.build.vm}/bin/run-nixos-vm
      '';

    in
    script.overrideAttrs (old: {
      meta = (old.meta or { }) // {
        platforms = lib.platforms.darwin;
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

        nix-instantiate --attr darwin.builder --show-trace
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
    diskSize = 20 * 1024;

    memorySize = 3 * 1024;

    forwardPorts = [
      { from = "host"; guest.port = 22; host.port = 22; }
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
  };
}
