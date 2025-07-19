{
  callPackage,
  desktop-file-utils,
  lib,
  stdenv,
  symlinkJoin,
  wrapGAppsHook3,
  xdg-utils,
}:
let
  hoppscotch-desktop-unwrapped = callPackage ./unwrapped.nix { };
in
symlinkJoin rec {
  name = "${pname}-${version}";
  pname = "hoppscotch-desktop";
  inherit (hoppscotch-desktop-unwrapped) version;

  paths = [ hoppscotch-desktop-unwrapped ];

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  postBuild = ''
    gappsWrapperArgs+=(
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix PATH : ${
          lib.makeBinPath [
            desktop-file-utils
            xdg-utils
          ]
        }
      ''}
    )

    wrapGAppsHook
  '';

  passthru = {
    unwrapped = hoppscotch-desktop-unwrapped;
  };

  inherit (hoppscotch-desktop-unwrapped) meta;
}
