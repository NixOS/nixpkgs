{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.rosetta;
  inherit (lib) types;
in
{
  options = {
    virtualisation.rosetta.enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable [Rosetta](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment) support.

        This feature requires the system to be a virtualised guest on an Apple silicon host.

        The default settings are suitable for the [UTM](https://docs.getutm.app/) virtualisation [package](https://search.nixos.org/packages?channel=unstable&show=utm&from=0&size=1&sort=relevance&type=packages&query=utm).
        Make sure to select 'Apple Virtualization' as the virtualisation engine and then tick the 'Enable Rosetta' option.
      '';
    };

    virtualisation.rosetta.mountPoint = lib.mkOption {
      type = types.str;
      default = "/run/rosetta";
      internal = true;
      description = ''
        The mount point for the Rosetta runtime inside the guest system.

        The proprietary runtime is exposed through a VirtioFS directory share and then mounted at this directory.
      '';
    };

    virtualisation.rosetta.mountTag = lib.mkOption {
      type = types.str;
      default = "rosetta";
      description = ''
        The VirtioFS mount tag for the Rosetta runtime, exposed by the host's virtualisation software.

        If supported, your virtualisation software should provide instructions on how register the Rosetta runtime inside Linux guests.
        These instructions should mention the name of the mount tag used for the VirtioFS directory share that contains the Rosetta runtime.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isAarch64;
        message = "Rosetta is only supported on aarch64 systems";
      }
    ];

    fileSystems."${cfg.mountPoint}" = {
      device = cfg.mountTag;
      fsType = "virtiofs";
    };

    nix.settings = {
      extra-platforms = [ "x86_64-linux" ];
      extra-sandbox-paths = [
        "/run/binfmt"
        cfg.mountPoint
      ];
    };
    boot.binfmt.registrations.rosetta = {
      interpreter = "${cfg.mountPoint}/rosetta";

      # The required flags for binfmt are documented by Apple:
      # https://developer.apple.com/documentation/virtualization/running_intel_binaries_in_linux_vms_with_rosetta
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
      fixBinary = true;
      matchCredentials = true;
      preserveArgvZero = true;

      # Remove the shell wrapper and call the runtime directly
      wrapInterpreterInShell = false;
    };
  };
}
