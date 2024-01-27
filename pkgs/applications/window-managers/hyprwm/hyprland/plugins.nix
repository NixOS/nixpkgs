{ lib
, callPackage
, pkg-config
, gcc13Stdenv
, hyprland
}:
let
  mkHyprlandPlugin =
    args@{ pluginName, ... }:
    gcc13Stdenv.mkDerivation (args // {
      pname = "${pluginName}";
      nativeBuildInputs = [ pkg-config ] ++ args.nativeBuildInputs or [ ];
      buildInputs = [ hyprland ]
        ++ hyprland.buildInputs
        ++ (args.buildInputs or [ ]);
      meta = args.meta // {
        description = (args.meta.description or "");
        longDescription = (args.meta.lonqDescription or "") +
          "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";
      };
    });

  plugins = {
    hy3 = { fetchFromGitHub, cmake, hyprland }:
      mkHyprlandPlugin rec {
        pluginName = "hy3";
        version = "0.34.0";

        src = fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "hl${version}";
          hash = "sha256-Jd1bSwelh7WA8aeYrV+CxxtpsmSITUDruKdNNLHdV7c=";
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
lib.mapAttrs (name: plugin: callPackage plugin { }) plugins

