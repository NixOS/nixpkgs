# System-level alternatives: coreutils, libc, FHS compatibility.
#
# These options let the user replace GNU userland components (and, later,
# libc) that NixOS uses by default, without changing any existing option.
#
# Step 7 of the project: the coreutils package.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  coreutils' = config.system.coreutils;
in
{
  _class = "nixos";

  options.system.coreutils = lib.mkOption {
    type = lib.types.nullOr lib.types.package;
    default = null;
    description = ''
      Package to use in place of GNU coreutils for the system's environment
      and for `system.build.coreutils`. When null (the default), GNU
      coreutils (`pkgs.coreutils`) is used, exactly as in a stock NixOS
      system.

      When set:
        - `system.build.coreutils` becomes the given package,
        - the package is added to the system PATH (`environment.systemPackages`).

      Examples: `pkgs.uutils-coreutils` or a custom busybox build.

      Note: NixOS modules that already embed `pkgs.coreutils` absolute paths
      keep them (they are part of their own evaluations). For a full,
      dependency-wide override, set `nixpkgs.overlays` directly, e.g.
      `nixpkgs.overlays = [ (final: prev: { coreutils = final.uutils-coreutils; }) ];`.
    '';
    example = lib.literalExpression "pkgs.uutils-coreutils";
  };

  config = lib.mkIf (coreutils' != null) {
    environment.systemPackages = [ coreutils' ];

    system.build.coreutils = coreutils';
  };
}