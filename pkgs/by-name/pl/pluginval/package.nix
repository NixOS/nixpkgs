{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  gtk3,
  freetype,
  fontconfig,
  xorg,
  curl,
  webkitgtk_4_1,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libXdmcp,
  libdeflate,
  lerc,
  xz,
  libwebp,
  libxkbcommon,
  libepoxy,
  libXtst,
  sqlite,
  ladspaH,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pluginval";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "Tracktion";
    repo = "pluginval";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4Lb3pcw0931o63OvTTaIm2UzvYDIjmnaCXGvKB4gwM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtk3
    freetype
    fontconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    curl
    webkitgtk_4_1
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libdeflate
    lerc
    xz
    libwebp
    libxkbcommon
    libepoxy
    libXtst
    sqlite
    ladspaH
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Debug")
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 pluginval_artefacts/Debug/pluginval $out/bin/pluginval
    runHook postInstall
  '';

  meta = {
    description = "Cross-platform plugin validator and tester for AU/VST2/VST3 plugins";
    homepage = "https://github.com/Tracktion/pluginval";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "pluginval";
  };
})
