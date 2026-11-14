{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.xtool;
in
{
  options.programs.xtool = {
    enable = lib.mkEnableOption "xtool, with usbmuxd for access to iOS devices";
    package = lib.mkPackageOption pkgs "xtool" { };

    sdk = {
      enable = lib.mkEnableOption "the Darwin SDK built from Xcode, linked into each user's `~/.swiftpm`";
      package = lib.mkOption {
        type = lib.types.package;
        default = cfg.package.sdk;
        defaultText = lib.literalExpression "config.programs.xtool.package.sdk";
        description = ''
          The Darwin SDK to link, built by the same xtool as {option}`programs.xtool.package`.
          Xcode must be added to the Nix store manually.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.usbmuxd.enable = true;

    # leaves an SDK installed with `xtool sdk install` alone
    systemd.user.tmpfiles.rules = lib.mkIf cfg.sdk.enable [
      "L %h/.swiftpm/swift-sdks/darwin.artifactbundle - - - - ${cfg.sdk.package}"
    ];
  };

  meta.maintainers = pkgs.xtool.meta.maintainers;
}
