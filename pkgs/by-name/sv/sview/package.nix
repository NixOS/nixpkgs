{
  cmake,
  fetchFromGitHub,
  fetchurl,
  ffmpeg,
  fontconfig,
  freetype,
  lib,
  libconfig,
  libGL,
  libx11,
  libxext,
  libxpm,
  libxrandr,
  makeFontsConf,
  makeWrapper,
  nanum,
  openal,
  openvr,
  pkg-config,
  stdenv,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "sview";
  version = "26_02";

  src = fetchFromGitHub {
    owner = "gkv311";
    repo = "sview";
    tag = version;
    hash = "sha256-UIA8bDGYVN8Zw23PkKprYrvcMubHzoquaSArLShu+aw=";
  };

  droidSansFallback = fetchurl {
    url = "https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/2d8961d99f3aa559dbd4b78b716ab36c456b43e1/data/fonts/DroidSansFallbackFull.ttf";
    sha256 = "sha256-I5IBVTBDi6/Ejt/ErubZ3iOH9iemE02Ks9/MmdIcgkA=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  cmakeFlags = [
    "-DUSE_UPDATER=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=/lib"
    "-DCMAKE_INSTALL_BINDIR=/bin"
    "-DCMAKE_INSTALL_DATAROOTDIR=/share"
  ];

  buildInputs = [
    freetype
    ffmpeg
    fontconfig
    libconfig
    libGL
    libx11
    libxext
    libxpm
    libxrandr
    openal
    openvr
  ];

  fontsConf = makeFontsConf {
    fontDirectories = [
      nanum
      "placeholder"
    ];
  };

  installPhase = ''
    runHook preInstall
    make & make install
    mkdir -p $out/share/sView/fonts
    cp ${droidSansFallback} $out/share/sView/fonts/DroidSansFallbackFull.ttf
    cp '${fontsConf}' $out/share/sView/fonts/fonts.conf
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/sView/fonts/fonts.conf \
      --replace-warn "placeholder" "$out/share/sView/fonts/";
    wrapProgram $out/bin/sView \
      --prefix PATH : "${zenity}/bin" \
      --set FONTCONFIG_FILE $out/share/sView/fonts/fonts.conf
  '';

  meta = {
    description = "Viewer for 3D stereoscopic videos and images";
    homepage = "https://www.sview.ru/en/";
    license = with lib.licenses; [
      cc-by-40
      gpl3Only
      asl20
    ];
    maintainers = with lib.maintainers; [ mx2uller ];
    mainProgram = "sView";
    platforms = lib.platforms.linux;
  };
}
