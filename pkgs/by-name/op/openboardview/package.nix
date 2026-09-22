{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  pkg-config,
  python3,
  SDL2,
  fontconfig,
  gtk3,
  wrapGAppsHook3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openboardview";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "OpenBoardView";
    repo = "OpenBoardView";
    tag = finalAttrs.version;
    hash = "sha256-rvCWzIbjEZOHh5diaeP4xVIRsMHqt4PGMuYOGfWvwhA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3Packages.jinja2
    wrapGAppsHook3
  ];
  buildInputs = [
    SDL2
    fontconfig
    gtk3
  ];

  postPatch = ''
    substituteInPlace src/openboardview/CMakeLists.txt \
      --replace "SDL2::SDL2main" ""
    substituteInPlace CMakeLists.txt --replace "fixup_bundle" "#fixup_bundle"
  '';

  cmakeFlags = [
    "-DGLAD_REPRODUCIBLE=On"
  ];

  dontWrapGApps = true;
  postFixup =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      mv "$out/openboardview.app" "$out/Applications/OpenBoardView.app"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      wrapGApp "$out/bin/${finalAttrs.pname}" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 ]}
    '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = ''.*\.90\..*'';
  };

  meta = {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    mainProgram = "openboardview";
    homepage = "https://github.com/OpenBoardView/OpenBoardView";
    changelog = "https://github.com/OpenBoardView/OpenBoardView/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ k3a ];
  };
})
