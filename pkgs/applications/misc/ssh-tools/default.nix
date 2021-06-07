{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ssh-tools";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "vaporup";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m0x9383p9ab4hdirncmrfha130iasa0v4cbif2y5nbxnxgh101r";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ssh-* $out/bin/
  '';

  meta = with lib; {
    description = "Collection of various tools using ssh";
    homepage = "https://github.com/vaporup/ssh-tools/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
