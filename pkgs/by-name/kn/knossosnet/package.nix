{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  copyDesktopItems,
  dotnetCorePackages,
  makeDesktopItem,
  nix-update-script,
  openal,
}:

buildDotnetModule (finalAttrs: {
  pname = "knossosnet";
  version = "1.3.14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/UjIh0Xmj3HpETPO7GN/cNqJdDg0owcGmd92n1ygZ4=";
  };

  # Build in .NET 10 LTS. Remove when addressed upstream.
  postPatch = ''
    substituteInPlace Knossos.NET/Knossos.NET.csproj VP.NET/VP.NET.csproj \
      --replace-fail '<TargetFramework>net6.0</' '<TargetFramework>net10.0</'
    substituteInPlace IonKiwi.lz4/IonKiwi.lz4.csproj \
      --replace-fail '<TargetFrameworks>net60</TargetFrameworks>' '<TargetFramework>net10.0</TargetFramework>'
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    for size in 48 64 96 128 256 512; do
      install -Dm444 packaging/linux/knossos-$size.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/knossos.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "knossos";
      categories = [ "Game" ];
      comment = "Multi-platform launcher for Freespace 2 Open";
      desktopName = "Knossos.NET";
      exec = "Knossos.NET";
      icon = "knossos";
      startupWMClass = "Knossos.NET";
    })
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  # IO errors in build due to solution building race
  enableParallelBuilding = false;
  executables = [ "Knossos.NET" ];
  nugetDeps = ./deps.json;
  projectFile = "Knossos.NET/Knossos.NET.csproj";

  runtimeDeps = [ openal ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-platform launcher for Freespace 2 Open";
    homepage = "https://fsnebula.org/knossos/";
    changelog = "https://github.com/KnossosNET/Knossos.NET/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ cdombroski ];
    platforms = lib.platforms.unix;
    mainProgram = "Knossos.NET";
  };
})
