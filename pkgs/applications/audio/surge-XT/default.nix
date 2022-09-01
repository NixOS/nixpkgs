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

let
  juce-lv2 = stdenv.mkDerivation {
    pname = "juce-lv2";
    version = "unstable-2022-03-30";

    # lv2 branch
    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      rev = "58b303e249670703f5d580e92bcc92b9a516fdfc";
      sha256 = "sha256-UgZpBDRvF+uvc+U1KnMaGZ1dCUL1MbjaQRFeCYbfBAc=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "release_xt_${version}";
    fetchSubmodules = true;
    sha256 = "sha256-UJYQdlJl7UXClv8+LTo2l2NHbIrWbYj2bNlO3ODCHKE=";
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

  cmakeFlags = [
    "-DJUCE_SUPPORTS_LV2=ON"
    "-DSURGE_JUCE_PATH=${juce-lv2}"
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
