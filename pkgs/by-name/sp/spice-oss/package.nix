{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  webkitgtk_4_1,
  zenity,
  curl,
  xorg,
  python3,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  libGL,
  libjack2,
  lerc,
  sqlite,
  expat,
  makeWrapper,
  nix-update-script,
}:
let
  version = "1.0.0";
in
stdenv.mkDerivation {
  pname = "spice-oss";
  inherit version;

  src = fetchFromGitHub {
      owner = "DatanoiseTV";
      repo = "spice-oss";
      rev = "5fba7517263343d5e296f0a329507add1118046f";
      hash = "sha256-NUd58Y2RdpdGnddTyqiv/qCAtKbeL+IXt+5hVzITsq8=";
      fetchSubmodules =  true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    freetype
    webkitgtk_4_1
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
    xorg.libXdmcp
    xorg.libXtst
    xorg.xvfb
    libsysprof-capture
    pcre2
    util-linux
    libGL
    libselinux
    libsepol
    libthai
    libxkbcommon
    libdatrie
    libepoxy
    lerc
    libjack2
    expat
    sqlite
  ];

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  preBuild = ''
    # fix LV2 build
    HOME=$(mktemp -d)
  '';

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';

  postInstall = ''
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugin wrapper around Pure Data to allow patching in a wide selection of DAWs";
    mainProgram = "plugdata";
    homepage = "https://plugdata.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.PowerUser64
      lib.maintainers.l1npengtul
    ];
  };
}
