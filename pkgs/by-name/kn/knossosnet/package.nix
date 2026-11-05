{
  buildDotnetModule,
  bash,
  coreutils,
  fetchFromGitHub,
  lib,
  openal,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "knossosnet";
  version = "1.3.13";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lx7PjqbEnF2xFrUtWJ6g2qSQ++k/hyjGLQ5bl7RqWM0=";
  };

  patches = [ ./dotnet-8-upgrade.patch ];

  postPatch = ''
    substituteInPlace Knossos.NET/Classes/KnUtils.cs \
      --replace-fail "\"/bin/bash\"" "\"${lib.getExe bash}\"" \
      --replace-fail "\"chmod -R " "\"${lib.getExe' coreutils "chmod"} -R " \
      --replace-fail "\"chmod {permissions}" "\"${lib.getExe' coreutils "chmod"} {permissions}"
  '';

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  projectFile = "Knossos.NET/Knossos.NET.csproj";
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
      startupWMClass = "Knossos.NET";
    })
  ];

  postInstall = ''
    for size in 48 64 96 128 256 512; do
      install -Dm444 packaging/linux/knossos-$size.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/knossos.png
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/KnossosNET/Knossos.NET/releases/tag/${finalAttrs.src.tag}";
    description = "Multi-platform launcher for Freespace 2 Open";
    homepage = "https://fsnebula.org/knossos/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    mainProgram = "Knossos.NET";
    maintainers = with lib.maintainers; [ cdombroski ];
    platforms = lib.platforms.unix;
  };
})
