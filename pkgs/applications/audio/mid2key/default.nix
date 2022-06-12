{ lib, stdenv, fetchFromGitHub, alsa-lib, libX11, libXi, libXtst, xorgproto }:

stdenv.mkDerivation rec {
  pname = "mid2key";
  version = "1";

  src = fetchFromGitHub {
    owner = "dnschneid";
    repo = "mid2key";
    rev = "v${version}";
    sha256 = "0j2vsjvdgx51nd1qmaa18mcy0yw9pwrhbv2mdwnf913bwsk4y904";
  };

  unpackPhase = "tar xvzf $src";

  buildInputs = [ alsa-lib libX11 libXi libXtst xorgproto ];

  buildPhase = "make";

  installPhase = "mkdir -p $out/bin && mv mid2key $out/bin";

  meta = with lib; {
    homepage = "http://code.google.com/p/mid2key/";
    description = "A simple tool which maps midi notes to simulated keystrokes";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
