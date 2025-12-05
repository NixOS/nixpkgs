{
  buildDotnetModule,
  fetchFromGitHub,
  lib,
  openal,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    rev = "v${version}";
    hash = "sha256-XaCBuZ4Hf2ISw3hVQ1s2Hp8PLxp2eFr+I7U5ttUDQvU=";
  };

  patches = [ ./dotnet-8-upgrade.patch ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nugetDeps = ./deps.json;
  executables = [ "Knossos.NET" ];

  runtimeDeps = [ openal ];

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "knossos";
      exec = "Knossos.NET";
      icon = "knossos";
      desktopName = "Knossos.NET";
      comment = "Multi-platform launcher for Freespace 2 Open";
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    install -Dm644 $src/packaging/linux/knossos-512.png $out/share/icons/hicolor/512x512/apps/knossos.png
  '';

  meta = with lib; {
    homepage = "https://github.com/KnossosNET/Knossos.NET";
    description = "Multi-platform launcher for Freespace 2 Open";
    license = licenses.gpl3Only;
    mainProgram = "Knossos.NET";
    maintainers = with maintainers; [ cdombroski ];
  };
}
