{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
}:

stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "release_xt_${version}";
    fetchSubmodules = true;
    sha256 = "sha256-r8CZxjmH9lfCizc95jRB4je+R/74zMqRMlGIZxxxriw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DSURGE_BUILD_LV2=TRUE"
  ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' has not been declared
    "-include cstdint"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
  postPatch = ''
    export XDG_DOCUMENTS_DIR=$(mktemp -d)
  '';

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
