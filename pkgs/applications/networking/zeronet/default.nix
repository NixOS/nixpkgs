{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "0.6.0";
  name = "zeronet-${version}";

  src = fetchFromGitHub {
    owner = "HelloZeroNet";
    repo = "ZeroNet";
    rev = "v${version}";
    sha256 = "0qzfm4k63rfxqz72c70d67yrp8jdndsfm891k0drd0prr0fm2fhw";
  };

  propagatedBuildInputs = with pythonPackages; [ gevent msgpack ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir $out/bin -p
    cp ./* -r $out/bin
  '';

  meta = {
    description = "Decentralized websites using Bitcoin crypto and BitTorrent network";
    homepage = https://zeronet.io/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
  };
}

