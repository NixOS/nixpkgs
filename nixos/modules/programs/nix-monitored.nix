{ pkgs, lib, config, ... }:

let
  cfg = config.nix.monitored;
in
{
  meta.maintainers = [ lib.maintainers.ners ];

  options.nix.monitored = with lib; {
    enable = mkEnableOption (mdDoc "nix-monitored, an improved output formatter for Nix");
    notify = mkEnableOption (mdDoc "notifications using libnotify");
    package = mkPackageOption pkgs "nix-monitored" { };
  };

  config =
    let package = cfg.package.override { withNotify = cfg.notify; }; in
    lib.mkIf cfg.enable {
      nix.package = package;
      nixpkgs.overlays = [
        (self: super: {
          nixos-rebuild = super.nixos-rebuild.override {
            nix = package;
          };
          nix-direnv = super.nix-direnv.override {
            nix = package;
          };
        })
      ];
    };
}
