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
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  pname = "openboardview";
  version = "9.95.0";

  src = fetchFromGitHub {
    owner = "OpenBoardView";
    repo = "OpenBoardView";
    rev = version;
    sha256 = "sha256-sKDDOPpCagk7rBRlMlZhx+RYYbtoLzJsrnL8qKZMKW8=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix gcc-13 build failure
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/OpenBoardView/OpenBoardView/commit/b03d0f69ec1611f5eb93f81291b4ba8c58cd29eb.patch";
      hash = "sha256-Hp7KgzulPC2bPtRsd6HJrTLu0oVoQEoBHl0p2DcOLQw=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
  ];
  buildInputs =
    [
      SDL2
      fontconfig
      gtk3
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
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
    lib.optionalString stdenv.isDarwin ''
      mkdir -p "$out/Applications"
      mv "$out/openboardview.app" "$out/Applications/OpenBoardView.app"
    ''
    + lib.optionalString (!stdenv.isDarwin) ''
      wrapGApp "$out/bin/${pname}" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 ]}
    '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = ''.*\.90\..*'';
  };

  meta = with lib; {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    mainProgram = "openboardview";
    homepage = "https://github.com/OpenBoardView/OpenBoardView";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ k3a ];
  };
}
