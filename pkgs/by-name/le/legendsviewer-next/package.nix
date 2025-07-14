{
  patches ? [ ],

  lib,
  stdenv,
  curl,

  callPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
let
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Kromtec";
    repo = "LegendsViewer-Next";
    tag = "v${version}";
    hash = "sha256-Fi4KARGsgDmplH/oG9OIxY2XqhHNYgUB6OxwtoTaCt4=";
  };

  frontend = callPackage ./frontend.nix {
    inherit version src patches;
  };

  backend = callPackage ./backend.nix {
    inherit version src patches;

    inherit frontend;
  };
in
stdenv.mkDerivation rec {
  pname = "legendsviewer-next";
  inherit version src patches;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Legends Viewer";
      genericName = "DF Legends Export Browser";
      comment = meta.description;
      icon = "${frontend}/dist/ceretelina.png";
      tryExec = meta.mainProgram;
      exec = meta.mainProgram;

      # Remove when https://github.com/Kromtec/LegendsViewer-Next/pull/55 gets
      # released
      terminal = true;

      categories = [
        "Game"
        "RolePlaying"
        "Simulation"
      ];
      keywords = [
        "df"
        "dwarf"
        "fortress"
        "legends"
        "viewer"
      ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preBuild

    mkdir -p $out

    ln -s ${backend}/bin $out/bin
    ln -s ${backend}/lib $out/lib

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    curl
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    timeout 10 $out/bin/LegendsViewer &
    sleep 5

    # Static server is up
    curl -f http://localhost:8081 | grep "<!doctype html>"

    # Version matches expected
    curl -f http://localhost:5054/api/version | grep ${version}

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Recreates Dwarf Fortress' Legends Mode from exported files";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.mit;

    mainProgram = "LegendsViewer";
    platforms = with lib.platforms; lib.intersectLists (darwin ++ linux) (x86_64 ++ aarch64);

    maintainers = with lib.maintainers; [ donottellmetonottellyou ];
  };
}
