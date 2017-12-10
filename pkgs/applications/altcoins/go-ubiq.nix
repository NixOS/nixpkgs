{ stdenv
, lib
, fetchFromGitHub
, go
, gnumake
, gcc
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "go-ubiq-${version}";
  version = "1.5.12";
  src = fetchFromGitHub {
    owner = "ubiq";
    repo = "go-ubiq";
    rev = "v${version}";
    sha256 = "0fdswpl0sc0cyidcnyhpxv360blbzrkkqrbmj449pi8ii0ybn33d";
  };
  buildInputs = [
    go
    gnumake
    gcc
  ];
  dontStrip = true;
  buildPhase = ''
    make gubiq
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp build/bin/gubiq $out/bin
  '';
  meta = with stdenv.lib; {
    homepage = https://ubiqsmart.com;
    description = "Ubiq fork of Geth";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = [ maintainers.offline ];
  };
}
