{ lib
, callPackage
, pkg-config
, stdenv
, hyprland
, fetchpatch
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
        version = "0.40.0";

        src = fetchFromGitHub {
          owner = "outfoxxed";
          repo = "hy3";
          rev = "hl0.40.0";
          hash = "sha256-Y9bIML3C5xyKKv+Yel4LUfSkScwGunOVZkg+Z1dPwHI=";
        };

        patches = [
          (fetchpatch {
            url = "https://github.com/outfoxxed/hy3/commit/33c8d761ff1c1d2264f7549a7bcfc010929d153c.patch";
            hash = "sha256-GcLQ38IVGB6VFMviKqWAM9ayjC2lpWekx3kqrnwsLhk=";
          })

          (fetchpatch {
            url = "https://github.com/outfoxxed/hy3/commit/400930e0391a0e13ebbc6a3b9fe162e00aaad89a.patch";
            hash = "sha256-DVrZSkXE4uKrAceGpUZklqrVRzV1CpNRgjpq0uOz0jk=";
          })
        ];

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
