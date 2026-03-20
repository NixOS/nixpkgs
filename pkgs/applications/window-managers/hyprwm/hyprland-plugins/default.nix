{
  config,
  lib,
  callPackage,
  pkg-config,
  hyprland,
}@topLevelArgs:
let

  mkHyprlandPlugin = lib.extendMkDerivation {
    constructDrv = topLevelArgs.hyprland.stdenv.mkDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        pluginName ? "",
        nativeBuildInputs ? [ ],
        buildInputs ? [ ],
        hyprland ? topLevelArgs.hyprland,
        ...
      }@args:

      {
        pname = "${pluginName}";
        nativeBuildInputs = [ pkg-config ] ++ nativeBuildInputs;
        buildInputs = [ hyprland ] ++ hyprland.buildInputs ++ buildInputs;
        meta = args.meta // {
          description = args.meta.description or "";
          longDescription =
            (args.meta.longDescription or "")
            + "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";

          platforms = args.meta.platforms or hyprland.meta.platforms or [ ];
        };
      };
  };

  plugins = lib.mergeAttrsList [
    { hy3 = import ./hy3.nix; }
    { hypr-darkwindow = import ./hypr-darkwindow.nix; }
    { hypr-dynamic-cursors = import ./hypr-dynamic-cursors.nix; }
    { hyprfocus = import ./hyprfocus.nix; }
    { hyprgrass = import ./hyprgrass.nix; }
    { hyprspace = import ./hyprspace.nix; }
    { hyprsplit = import ./hyprsplit.nix; }
    (import ./hyprland-plugins.nix)
    (lib.optionalAttrs config.allowAliases {
      hycov = throw "hyprlandPlugins.hycov has been removed because it has been marked as broken since September 2024."; # Added 2025-10-12
      hyprscroller = throw "hyprlandPlugins.hyprscroller has been removed as the upstream project is deprecated. Consider using `hyprlandPlugins.hyprscrolling`."; # Added 2025-05-09
    })
  ];
in
(lib.mapAttrs (name: plugin: callPackage plugin { inherit mkHyprlandPlugin; }) plugins)
// {
  inherit mkHyprlandPlugin;
}
