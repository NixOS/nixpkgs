{ stdenv, fetchFromGitHub, fetchzip, cmake, pkgconfig, lv2, alsaLib, libjack2,
  freetype, libX11, gtk3, pcre, libpthreadstubs, libXdmcp, libxkbcommon,
  epoxy, at-spi2-core, dbus, curl, fftwFloat }:

let
  pname = "HybridReverb2";
  version = "2.1.1";
  owner = "jpcima";
  DBversion = "1.0.0";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  impulseDB = fetchzip {
    url = "https://github.com/${owner}/${pname}-impulse-response-database/archive/v${DBversion}.zip";
    sha256 = "1hlfxbbkahm1k2sk3c3n2mjaz7k80ky3r55xil8nfbvbv0qan89z";
  };

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "15mba9qvlis0qrklr50wp3jdysvmk33m7pvclp0k1is9pirj97cb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ lv2 alsaLib libjack2 freetype libX11 gtk3 pcre
    libpthreadstubs libXdmcp libxkbcommon epoxy at-spi2-core dbus curl fftwFloat ];

  cmakeFlags = [
    "-DHybridReverb2_AdvancedJackStandalone=ON"
    "-DHybridReverb2_UseLocalDatabase=ON"
  ];

  postInstall = ''
    mkdir -p $out/share/${pname}/
    cp  -r ${impulseDB}/* $out/share/${pname}/
  '';

  meta = with stdenv.lib; {
    homepage = http://www2.ika.ruhr-uni-bochum.de/HybridReverb2;
    description = "Reverb effect using hybrid impulse convolution";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
