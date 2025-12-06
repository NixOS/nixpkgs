{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qt6,
  libuuid,
  seafile-shared,
  jansson,
  libsearpc,
  seadrive-fuse,
}:

stdenv.mkDerivation rec {
  pname = "seadrive-gui";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seadrive-gui";
    rev = "v${version}";
    hash = "sha256-TAmLHoJmFZyGa0wMBBPBWYOOdBCiMBdVfrIBTCZ8Sig=";
  };

  postPatch = [
    ''
      substituteInPlace CMakeLists.txt --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.9)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10)'
    ''
    # Use plain signature for target_link_libraries
    ''
      substituteInPlace CMakeLists.txt --replace-fail \
      'TARGET_LINK_LIBRARIES(seadrive-gui PRIVATE Qt6::DBus)' \
      'TARGET_LINK_LIBRARIES(seadrive-gui Qt6::DBus)'
    ''
  ];

  nativeBuildInputs = [
    libuuid
    pkg-config
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qt5compat
    seafile-shared
    jansson
    libsearpc
    seadrive-fuse
    qt6.qtwebengine
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seadrive-fuse ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seadrive-gui";
    changelog = "https://github.com/haiwen/seadrive-gui/releases/tag/${src.rev}";
    description = "GUI part of Seafile drive.";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      schmittlauch
    ];
    mainProgram = "seadrive-gui";
  };
}
