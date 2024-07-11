{ lib
, callPackage
, pkg-config
, stdenv
, hyprland
}:
let
  mkHyprlandPlugin = hyprland:
    args@{ pluginName, ... }:
    stdenv.mkDerivation (args // {
      pname = "${pluginName}";
      nativeBuildInputs = [ pkg-config ] ++ args.nativeBuildInputs or [ ];
      buildInputs = [ hyprland ]
        ++ hyprland.buildInputs
        ++ (args.buildInputs or [ ]);
      meta = args.meta // {
        description = args.meta.description or "";
        longDescription = (args.meta.longDescription or "") +
          "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";
      };
    });

  plugins = {
    hy3 = { fetchFromGitHub, cmake, hyprland }:
      mkHyprlandPlugin hyprland rec {
        pluginName = "hy3";
        version = "0.41.0";

        src = fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "hl${version}";
          hash = "sha256-gEEWWlQRvejSR2RRg78Lubz6siIgknqj6CslveyyIP4=";
        };

        nativeBuildInputs = [ cmake ];

        dontStrip = true;

        meta = {
          homepage = "https://github.com/outfoxxed/hy3";
          description = "Hyprland plugin for an i3 / sway like manual tiling layout";
          license = lib.licenses.gpl3;
          platforms = lib.platforms.linux;
          maintainers = with lib.maintainers; [ aacebedo ];
        };
      };
  };
in
(lib.mapAttrs (name: plugin: callPackage plugin { }) plugins) // { inherit mkHyprlandPlugin; }
