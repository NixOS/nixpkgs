{ stdenv
, lib
, fetchFromGitHub
, cmake
, gitMinimal
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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "release_xt_${version}";
    branchName = "release-xt/${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    sha256 = "sha256-q6qs/OhIakF+Gc8Da3pnfkUGYDUoJbvee0o8dfrRI2U=";
  };

  nativeBuildInputs = [
    cmake
    gitMinimal
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
