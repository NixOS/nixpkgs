{ stdenv
, fetchurl
, pulseaudio
, zlib
, alsaLib
, autoPatchelfHook
, lib
}:

stdenv.mkDerivation rec {
  name = "studio-link-${version}";
  version = "21.07.0";

  src = fetchurl {
    url = "https://download.studio.link/releases/v${version}-stable/linux/studio-link-standalone-v${version}.tar.gz";
    sha256 = "sha256-4CkijAlenhht8tyk3nBULaBPE0GBf6DVII699/RmmWI=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ pulseaudio zlib alsaLib ];

  sourceRoot = ".";

  installPhase = ''
    install -D -m755 studio-link-standalone-v* $out/bin/studio-link
  '';

  meta = with lib; {
    homepage = "https://studio.link";
    description = "High quality Audio-over-IP Connections";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fooker ];
  };
}
