{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "nethack-3d";
  version = "1.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JamesIV4";
    repo = "nethack-3d";
    rev = finalAttrs.version;
    hash = "sha256-rj0SZYWcp4dAcRWchMnhCWoErAPAUfv0e3CmLO0gf2A=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-3Srw5qDUMprcE7hWkaG8lSfMDNWbBloxvMplvf7iGgM=";
  npmBuildScript = "build:electron";
  npmInstallFlags = [ "--legacy-peer-deps" ];
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [ electron ];

  desktopItems = [
    (makeDesktopItem {
      name = "nethack-3d";
      exec = "nethack-3d";
      desktopName = "NetHack 3D";
      comment = "Classic NetHack presented as an interactive 3D dungeon";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/nethack-3d $out/bin
    cp -r dist electron package.json $out/share/nethack-3d/
    makeWrapper ${lib.getExe electron} $out/bin/nethack-3d \
      --add-flags $out/share/nethack-3d \
      --add-flags "--no-sandbox"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Classic NetHack presented as an interactive 3D dungeon";
    homepage = "https://github.com/JamesIV4/nethack-3d";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # uses neth4ck WASM builds
    ];
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.bitbloxhub ];
    platforms = lib.platforms.linux;
    mainProgram = "nethack-3d";
  };
})
