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
      mkHyprlandPlugin hyprland {
        pluginName = "hy3";
        version = "0.36.0-unstable-2024-03-06";

        src = fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "a392bfd13caf865ccf6b9df6917b67cc3a054b82";
          hash = "sha256-QuapQR9DJI9+vt7xqULYIXx2QCCX1I/YB50c+7ReexU=";
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
