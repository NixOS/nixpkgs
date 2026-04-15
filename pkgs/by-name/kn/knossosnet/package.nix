{
  buildDotnetModule,
  fetchFromGitHub,
  lib,
  openal,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    tag = "v${version}";
    hash = "sha256-UvkJiUQ1magZZ4ylKxelQab/xxARj8T6Zl/Kh/bXaqI=";
  };

  patches = [ ./dotnet-8-upgrade.patch ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nugetDeps = ./deps.json;
  executables = [ "Knossos.NET" ];

  # IO errors in build due to solution building race
  enableParallelBuilding = false;

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
    install -Dm444 $src/packaging/linux/knossos-512.png $out/share/icons/hicolor/512x512/apps/knossos.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/KnossosNET/Knossos.NET/releases/tag/v${version}";
    description = "Multi-platform launcher for Freespace 2 Open";
    homepage = "https://fsnebula.org/knossos/";
    license = lib.licenses.gpl3Only;
    mainProgram = "Knossos.NET";
    maintainers = with lib.maintainers; [ cdombroski ];
    platforms = lib.platforms.unix;
  };
}
