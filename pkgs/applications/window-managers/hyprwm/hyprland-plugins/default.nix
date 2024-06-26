{
  lib,
  callPackage,
  pkg-config,
  stdenv,
  hyprland,
}:
let
  mkHyprlandPlugin =
    hyprland:
    args@{ pluginName, ... }:
    stdenv.mkDerivation (
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
    (import ./hyprland-plugins.nix)
  ];
in
(lib.mapAttrs (name: plugin: callPackage plugin { inherit mkHyprlandPlugin; }) plugins)
// {
  inherit mkHyprlandPlugin;
}
