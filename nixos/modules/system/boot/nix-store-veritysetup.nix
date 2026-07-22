{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.boot.initrd.nix-store-veritysetup;
in
{
  meta.maintainers = with lib.maintainers; [ nikstur ];

  options.boot.initrd.nix-store-veritysetup = {
    enable = lib.mkEnableOption "nix-store-veritysetup";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.initrd.systemd.dmVerity.enable;
        message = "nix-store-veritysetup requires dm-verity in the systemd initrd.";
      }
    ];

    boot.initrd.systemd = {
      contents = {
        "/etc/systemd/system-generators/nix-store-veritysetup-generator".source =
          "${lib.getExe pkgs.nix-store-veritysetup-generator}";
      };

      storePaths = [
        "${config.boot.initrd.systemd.package}/bin/systemd-escape"
      ];
    };

  };
}
