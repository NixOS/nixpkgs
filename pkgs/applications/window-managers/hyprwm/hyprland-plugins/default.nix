{
  lib,
  callPackage,
  pkg-config,
}:
let
  mkHyprlandPlugin =
    hyprland:
    args@{ pluginName, ... }:
    hyprland.stdenv.mkDerivation (
      args
      // {
        pname = "${pluginName}";
        nativeBuildInputs = [ pkg-config ] ++ args.nativeBuildInputs or [ ];
        buildInputs = [ hyprland ] ++ hyprland.buildInputs ++ (args.buildInputs or [ ]);
        meta = args.meta // {
          description = args.meta.description or "";
          longDescription =
            (args.meta.longDescription or "")
            + "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";
        };
      }
    );

  plugins = lib.mergeAttrsList [
    { hy3 = import ./hy3.nix; }
    { hycov = import ./hycov.nix; }
    { hypr-dynamic-cursors = import ./hypr-dynamic-cursors.nix; }
    { hyprfocus = import ./hyprfocus.nix; }
    { hyprgrass = import ./hyprgrass.nix; }
    {
      hyprscroller = throw "hyprlandPlugins.hyprscroller has been removed as the upstream project is deprecated. Consider using `hyprlandPlugins.hyprscrolling`.";
    } # Added 2025-05-09
    { hyprspace = import ./hyprspace.nix; }
    { hyprsplit = import ./hyprsplit.nix; }
    (import ./hyprland-plugins.nix)
  ];
in
(lib.mapAttrs (name: plugin: callPackage plugin { inherit mkHyprlandPlugin; }) plugins)
// {
  inherit mkHyprlandPlugin;
}
