{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, lv2
, alsa-lib
, libjack2
, freetype
, libX11
, gtk3
, pcre
, libpthreadstubs
, libXdmcp
, libxkbcommon
, libepoxy
, at-spi2-core
, dbus
, curl
, fftwFloat
}:

let
  pname = "HybridReverb2";
  version = "2.1.2";
  owner = "jpcima";
  DBversion = "1.0.0";
in

stdenv.mkDerivation rec {
  inherit pname version;

  impulseDB = fetchFromGitHub {
    inherit owner;
    repo = "HybridReverb2-impulse-response-database";
    rev = "v${DBversion}";
    sha256 = "sha256-PyGrMNhrL2cRjb2UPPwEaJ6vZBV2sDG1mKFCNdfqjsI=";
  };

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "16r20plz1w068bgbkrydv01a991ygjybdya3ah7bhp3m5xafjwqb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    lv2
    alsa-lib
    libjack2
    freetype
    libX11
    gtk3
    pcre
    libpthreadstubs
    libXdmcp
    libxkbcommon
    libepoxy
    at-spi2-core
    dbus
    curl
    fftwFloat
  ];

  cmakeFlags = [
    "-DHybridReverb2_AdvancedJackStandalone=ON"
    "-DHybridReverb2_UseLocalDatabase=ON"
  ];

  postInstall = ''
    mkdir -p $out/share/${pname}/
    cp  -r ${impulseDB}/* $out/share/${pname}/
  '';

  meta = with lib; {
    homepage = "https://github.com/jpcima/HybridReverb2";
    description = "Reverb effect using hybrid impulse convolution";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
