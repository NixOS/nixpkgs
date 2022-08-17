{ config, pkgs, lib, ... }:
let
  cfg = config.xdg.xdg-open;
  implementations = {
    "xdg-utils" = pkgs: pkgs.xdg-utils;
    "xdg-open-with-portal" = pkgs: pkgs.xdg-open-with-portal;
    "handlr" = pkgs: pkgs.handlr;
  };
  xdg-utils-patched = pkgs: target: (pkgs.xdg-utils.overrideAttrs (old: {
    postInstall = (old.postInstall or "") +
      ''
        sed -i '2i if ${target pkgs}/bin/xdg-open "$1"; then exit 0; fi;' $out/bin/xdg-open
      '';
  }));
  impl = implementations.${cfg.implementation};
in
{
  options.xdg.xdg-open = {
    enable = lib.mkEnableOption "adding an xdg-open implementation to the path (environment.systemPackages)";
    implementation = lib.mkOption {
      description = "Which implementation to use";
      type = lib.types.enum (builtins.attrNames implementations);
      # This makes the most sense as a default for NixOS
      # due to https://github.com/NixOS/nixpkgs/issues/160923
      default = "xdg-open-with-portal";
    };
    # TODO:
    # Consider removing this option later, if packages start using xdg-open on the path more reliably?
    # See discussion here https://discourse.nixos.org/t/should-we-support-encoding-runtime-dependencies-without-requiring-a-specific-implementation/21031/17
    # for potential future approaches to runtime swappable dependencies
    useXdgUtilsOverlay = lib.mkEnableOption "replacing xdg-utils's xdg-open using an overlay. Applies more reliably but causes mass rebuilds.";
  };

  config = lib.mkIf cfg.enable {
    # TODO: consider making a small wrapper package around impl so only /bin/xdg-open ends up on path?
    environment.systemPackages = [ (lib.hiPrio (impl pkgs)) ];

    nixpkgs.overlays = lib.mkIf (cfg.useXdgUtilsOverlay && cfg.implementation != "xdg-utils") [
      (self: super: {
        xdg-utils = xdg-utils-patched super impl;
      })
    ];
  };
}
