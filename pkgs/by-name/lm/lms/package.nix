{
  lib,
  stdenv,
  fetchFromGitHub,
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
  xxHash,
  pugixml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lms";
  version = "3.74.0";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "lms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D1Sg6XzZ8t/dFKrVh7k+KGLg2r6LeLGJk4FweVb4L1A=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
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
    xxHash
    pugixml
  ];

  postPatch = ''
    substituteInPlace src/libs/core/include/core/SystemPaths.hpp --replace-fail "/etc" "$out/share/lms"
  '';

  postInstall = ''
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/bin/ffmpeg" "${lib.getExe ffmpeg}"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/Wt/resources" "${wt}/share/Wt/resources"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/lms/docroot" "$out/share/lms/docroot"
    substituteInPlace $out/share/lms/lms.conf --replace-fail "/usr/share/lms/approot" "$out/share/lms/approot"
    substituteInPlace $out/share/lms/default.service --replace-fail "/usr/bin/lms" "$out/bin/lms"
    install -Dm444 $out/share/lms/default.service -T $out/lib/systemd/system/lmsd.service
  '';

  meta = {
    homepage = "https://github.com/epoupon/lms";
    changelog = "https://github.com/epoupon/lms/releases/tag/${finalAttrs.src.rev}";
    description = "Lightweight Music Server - Access your self-hosted music using a web interface";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lms";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
})
