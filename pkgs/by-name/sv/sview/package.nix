{
  fetchFromGitHub,
  fetchurl,
  ffmpeg_4,
  fontconfig,
  gtk2,
  lib,
  libconfig,
  libGL,
  libXpm,
  makeFontsConf,
  makeWrapper,
  nanum,
  openal,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "sview";
  version = "20_08";

  src = fetchFromGitHub {
    owner = "gkv311";
    repo = "sview";
    rev = version;
    hash = "sha256-mbEacdBQchziXoZ5vJUiEpa/iHeXeaozte2aXs50/Fo=";
  };

  droidSansFallback = fetchurl {
    url = "https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/main/data/fonts/DroidSansFallbackFull.ttf";
    sha256 = "sha256-I5IBVTBDi6/Ejt/ErubZ3iOH9iemE02Ks9/MmdIcgkA=";
  };

  nativeBuildInputs = [
    ffmpeg_4
    gtk2
    libconfig
    libGL
    libXpm
    makeWrapper
    openal
    pkg-config
  ];

  fontsConf = makeFontsConf {
    fontDirectories = [
      nanum
      "placeholder"
    ];
  };

  installPhase = ''
    make install APP_PREFIX=$out DISABLE_UPDATER=1
    mkdir -p $out/share/sView/fonts
    cp ${droidSansFallback} $out/share/sView/fonts/DroidSansFallbackFull.ttf
    cp '${fontsConf}' $out/share/sView/fonts/fonts.conf
  '';

  postFixup = ''
    substituteInPlace $out/share/sView/fonts/fonts.conf \
      --replace-warn "placeholder" "$out/share/sView/fonts/";
    wrapProgram $out/bin/sView \
      --set StShare $out/share/sView \
      --set FONTCONFIG_FILE $out/share/sView/fonts/fonts.conf
  '';

  meta = with lib; {
    description = "Cross-platform solution to view 3D stereoscopic videos and images.";
    homepage = "https://www.sview.ru/en/";
    license = with licenses; [
      cc-by-40
      gpl3Only
    ];
    maintainers = with maintainers; [ mx2uller ];
    mainProgram = "sview";
    platforms = platforms.linux;
  };
}
