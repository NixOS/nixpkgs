{
  fyrox-project-manager-unwrapped,
  lib,
  makeWrapper,
  makeDesktopItem,
  buildPackages,
  stdenv,
}:
let
  unwrapped = fyrox-project-manager-unwrapped;
in
stdenv.mkDerivation {
  pname = "fyrox-project-manager";
  inherit (unwrapped) version meta;

  dontUnpack = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    makeWrapper ${lib.getExe unwrapped} $out/bin/fyrox-project-manager \
      --suffix PATH : ${
        lib.makeBinPath [
          buildPackages.pkg-config
          buildPackages.rustc
          buildPackages.cargo
        ]
      } \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath unwrapped.buildInputs} \
      --suffix PKG_CONFIG_PATH : ${lib.makeSearchPathOutput "dev" "lib/pkgconfig" unwrapped.buildInputs}

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      categories = [
        "Development"
        "IDE"
      ];
      comment = "Fyrox project manager";
      desktopName = "Fyrox";
      exec = "fyrox-project-manager";
      keywords = [
        "Development"
        "IDE"
        "Game development"
        "Game engine"
      ];
      icon = "${unwrapped}/share/icons/hicolor/128x128/apps/fyrox.png";
      name = "fyrox-project-manager";
      terminal = false;
    })
  ];
}
