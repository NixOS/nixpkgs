{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.virtualisation.fex;
  common = {
    # Settings taken from the files in `lib/binfmt.d` of the `fex` package
    preserveArgvZero = true;
    openBinary = true;
    matchCredentials = true;
    fixBinary = true;

    offset = 0;
    interpreter = lib.getExe' cfg.package "FEXInterpreter";
    wrapInterpreterInShell = false;
  };
  magics = lib.importJSON ../system/boot/binary-magics.json;
in

{
  options.virtualisation.fex = {
    enable = lib.mkEnableOption "emulation of x86 binaries on aarch64 hosts using FEX";
    package = lib.mkPackageOption pkgs "fex" { };

    addToNixSandbox = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to add the FEX emulator to {option}`nix.settings.extra-platforms`.
        Disable this to use remote builders for x86 platforms, while allowing testing binaries locally.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.hostPlatform.isAarch64;
        message = "FEX emulation is only supported on aarch64.";
      }
    ];

    environment.systemPackages = [ cfg.package ];
    boot.binfmt.registrations = {
      "FEX-x86" = common // magics.i386-linux;
      "FEX-x86_64" = common // magics.x86_64-linux;
    };

    nix.settings = lib.mkIf cfg.addToNixSandbox {
      extra-platforms = [
        "x86_64-linux"
        "i386-linux"
      ];
      extra-sandbox-paths = [
        "/run/binfmt"
        "${cfg.package}"
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ andre4ik3 ];
}
