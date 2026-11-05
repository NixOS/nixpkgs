{
  lib,
  fetchFromGitHub,
  bash,
  buildDotnetModule,
  copyDesktopItems,
  coreutils,
  dotnetCorePackages,
  makeDesktopItem,
  nix-update-script,
  openal,
}:

buildDotnetModule (finalAttrs: {
  pname = "knossosnet";
  version = "1.3.13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lx7PjqbEnF2xFrUtWJ6g2qSQ++k/hyjGLQ5bl7RqWM0=";
  };

  patches = [ ./dotnet-8-upgrade.patch ];

  postPatch = ''
    # Let appimages be executable
    substituteInPlace Knossos.NET/Classes/KnUtils.cs \
      --replace-fail "\"/bin/bash\"" "\"${lib.getExe bash}\"" \
      --replace-fail "\"chmod -R " "\"${lib.getExe' coreutils "chmod"} -R " \
      --replace-fail "\"chmod {permissions}" "\"${lib.getExe' coreutils "chmod"} {permissions}"
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

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
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
