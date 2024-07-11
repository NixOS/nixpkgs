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
}:

stdenv.mkDerivation rec {
  pname = "lms";
  version = "3.51.1";
  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "lms";
    rev = "v${version}";
    hash = "sha256-5lEbrB218EVVHIzo1efvQYybut2OpfDKpLlRs0brhXg=";
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
  ];

  postPatch = ''
    substituteInPlace src/lms/main.cpp --replace-fail "/etc/lms.conf" "$out/share/lms/lms.conf"
    substituteInPlace src/tools/recommendation/LmsRecommendation.cpp --replace-fail "/etc/lms.conf" "$out/share/lms/lms.conf"
    substituteInPlace src/tools/db-generator/LmsDbGenerator.cpp --replace-fail "/etc/lms.conf" "$out/share/lms/lms.conf"
    substituteInPlace src/tools/cover/LmsCover.cpp --replace-fail "/etc/lms.conf" "$out/share/lms/lms.conf"
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

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
      --prefix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath [libSM libICE]}"
    wrapProgram $out/bin/lms-metadata \
      --prefix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath [libSM libICE]}"
    wrapProgram $out/bin/lms-recommendation \
      --prefix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath [libSM libICE]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/epoupon/lms";
    description = "Lightweight Music Server - Access your self-hosted music using a web interface";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "lms";
    maintainers = with maintainers; [ mksafavi ];
  };
}
