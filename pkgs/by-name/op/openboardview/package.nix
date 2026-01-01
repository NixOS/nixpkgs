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
}:

stdenv.mkDerivation rec {
  pname = "openboardview";
<<<<<<< HEAD
  version = "9.95.2";
=======
  version = "9.95.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "OpenBoardView";
    repo = "OpenBoardView";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-B5VnuycRt8h7Cz3FTIbhcGcXuA60zPCz0FMvFENTwws=";
=======
    hash = "sha256-sKDDOPpCagk7rBRlMlZhx+RYYbtoLzJsrnL8qKZMKW8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  patches = [
<<<<<<< HEAD
    (fetchpatch {
      name = "fix-darwin-build.patch";
      url = "https://github.com/OpenBoardView/OpenBoardView/commit/a1de2e5de908afd83eceed757260f6425314af2e.patch?full_index=1";
      hash = "sha256-DK+K4F0+QGqaoWCyc8AvuIsaiTCqhAG6AsTNg2hegh0=";
=======
    # Fix gcc-13 build failure
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/OpenBoardView/OpenBoardView/commit/b03d0f69ec1611f5eb93f81291b4ba8c58cd29eb.patch";
      hash = "sha256-Hp7KgzulPC2bPtRsd6HJrTLu0oVoQEoBHl0p2DcOLQw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
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
      wrapGApp "$out/bin/${pname}" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 ]}
    '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = ''.*\.90\..*'';
  };

<<<<<<< HEAD
  meta = {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    mainProgram = "openboardview";
    homepage = "https://github.com/OpenBoardView/OpenBoardView";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ k3a ];
=======
  meta = with lib; {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    mainProgram = "openboardview";
    homepage = "https://github.com/OpenBoardView/OpenBoardView";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ k3a ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
