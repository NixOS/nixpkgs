{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  cmake,
  pkg-config,
  gtest,
  boost,
  wt,
  taglib,
  libconfig,
  libarchive,
  graphicsmagick,
  ffmpeg,
  zlib,
  libSM,
  libICE,
  stb,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "lms";
  version = "3.61.0";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "lms";
    rev = "v${version}";
    hash = "sha256-q2LnJhIQYdjvVk+fQQ2tjoEw046DUR1o+RUG2bp/w3M=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    gtest
    boost
    wt
    taglib
    libconfig
    libarchive
    graphicsmagick
    ffmpeg
    zlib
    libSM
    libICE
    stb
    openssl
  ];

  postPatch = ''
    substituteInPlace src/libs/core/include/core/SystemPaths.hpp --replace-fail "/etc" "$out/share/lms"
  '';

  postInstall = ''
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/bin/ffmpeg" "${ffmpeg}/bin/ffmpeg"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/Wt/resources" "${wt}/share/Wt/resources"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/lms/docroot" "$out/share/lms/docroot"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/lms/approot" "$out/share/lms/approot"
    substituteInPlace $out/share/lms/default.service --replace-fail "/usr/bin/lms" "$out/bin/lms"
    install -Dm444 $out/share/lms/default.service -T $out/lib/systemd/system/lmsd.service
  '';

  preFixup = ''
    wrapProgram $out/bin/lms \
      --prefix LD_LIBRARY_PATH : "${
        lib.strings.makeLibraryPath [
          libSM
          libICE
        ]
      }"
    wrapProgram $out/bin/lms-metadata \
      --prefix LD_LIBRARY_PATH : "${
        lib.strings.makeLibraryPath [
          libSM
          libICE
        ]
      }"
    wrapProgram $out/bin/lms-recommendation \
      --prefix LD_LIBRARY_PATH : "${
        lib.strings.makeLibraryPath [
          libSM
          libICE
        ]
      }"
  '';

  meta = {
    homepage = "https://github.com/epoupon/lms";
    changelog = "https://github.com/epoupon/lms/releases/tag/${src.rev}";
    description = "Lightweight Music Server - Access your self-hosted music using a web interface";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lms";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
