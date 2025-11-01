/*
  This is the Lix variant of the `nix.` option tree.

  This module is in charge of rewiring various programs to
  reuse Lix directly.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf types literalExpression;
  cfg = config.lix;
in
{
  options.lix = {
    enable = mkEnableOption "a Lix-based NixOS system";

    packages = mkOption {
      type = types.raw;
      default = pkgs.lixPackageSets.stable;
      defaultText = literalExpression "pkgs.lixPackageSets.stable";
      example = literalExpression "pkgs.lixPackageSets.latest";
      description = ''
        This option specifies the set of Lix packages instance to use throughout the system.

        It must contain the `lix` attribute at least.
      '';
    };
  };

  config = mkIf cfg.enable {
    nix.package = cfg.packages.lix;

    nixpkgs.overlays = [
      (self: scope: {
        nixpkgs-review = scope.nixpkgs-review.override {
          nix = cfg.packages.lix;
        };

        nix-direnv = scope.nix-direnv.override {
          nix = cfg.packages.lix;
        };

        nix-fast-build = scope.nix-fast-build.override {
          inherit (self) nix-eval-jobs;
        };

        inherit (cfg.packages) nix-eval-jobs;

        nix-serve-ng = lib.pipe (scope.nix-serve-ng.override { nix = cfg.packages.lix; }) [
          (scope.haskell.lib.compose.enableCabalFlag "lix")
          (scope.haskell.lib.compose.overrideCabal (drv: {
            # https://github.com/aristanetworks/nix-serve-ng/issues/46
            # Resetting (previous) broken flag since it may be related to C++ Nix
            broken = lib.versionAtLeast self.lix.version "2.93";
          }))
        ];

        colmena = scope.colmena.override {
          nix = cfg.packages.lix;
          inherit (self) nix-eval-jobs;
        };

        nix-update = scope.nix-update.override {
          nix = cfg.packages.lix;
          inherit (self) nixpkgs-review;
        };
      })
    ];
  };
}
