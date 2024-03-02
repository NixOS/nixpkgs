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
        version = "unstable-2024-02-23";

        src = fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "029a2001361d2a4cbbe7447968dee5d1b1880298";
          hash = "sha256-8LKCXwNU6wA8o6O7s9T2sLWbYNHaI1tYU4YMjHkNLZQ=";
        };

        nativeBuildInputs = [ cmake ];

        dontStrip = true;

        meta = with lib; {
          homepage = "https://github.com/outfoxxed/hy3";
          description = "Hyprland plugin for an i3 / sway like manual tiling layout";
          license = licenses.gpl3;
          platforms = platforms.linux;
          maintainers = [ maintainers.aacebedo ];
        };
      };
  };
in
(lib.mapAttrs (name: plugin: callPackage plugin { }) plugins) // { inherit mkHyprlandPlugin; }
