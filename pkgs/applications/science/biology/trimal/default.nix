{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "trimal";
  version = "1.4.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "scapella";
    rev = "v${version}";
    sha256 = "0isc7s3514di4z953xq53ncjkbi650sh4q9yyw5aag1n9hqnh7k0";
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a trimal readal statal $out/bin
  '';

  meta = with lib; {
    description = "A tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ maintainers.bzizou ];
  };
}
