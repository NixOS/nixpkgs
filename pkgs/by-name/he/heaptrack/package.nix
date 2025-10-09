{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  makeBinaryWrapper,
  zlib,
  boost,
  libunwind,
  elfutils,
  sparsehash,
  zstd,
  kdePackages,
}:

stdenv.mkDerivation {
  pname = "heaptrack";
  version = "1.5.0-unstable-2025-07-21";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sdk";
    repo = "heaptrack";
    rev = "9db5d53df554959478575e080648f6854d362faf";
    hash = "sha256-8NLpp/+PK3wIB5Sx0Z1185DCDQ18zsGj9Wp5YNKgX8E=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    makeBinaryWrapper
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    boost
    libunwind
    sparsehash
    zstd
  ]
  ++ (with kdePackages; [
    qtbase
    kio
    kitemmodels
    threadweaver
    kconfigwidgets
    kcoreaddons
    kdiagram
  ])

  ++ lib.optionals stdenv.hostPlatform.isLinux [
    elfutils
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper \
      $out/Applications/KDE/heaptrack_gui.app/Contents/MacOS/heaptrack_gui \
      $out/bin/heaptrack_gui
  '';

  meta = with lib; {
    description = "Heap memory profiler for Linux";
    homepage = "https://github.com/KDE/heaptrack";
    license = licenses.lgpl21Plus;
    mainProgram = "heaptrack_gui";
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
