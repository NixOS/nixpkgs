{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {

  pname = "terranix";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "terranix";
    rev = version;
    sha256 = "030067h3gjc02llaa7rx5iml0ikvw6szadm0nrss2sqzshsfimm4";
  };

  installPhase = ''
    mkdir -p $out
    mv bin core modules lib $out/
  '';

  meta = with lib; {
    description = "A NixOS like terraform-json generator";
    homepage = "https://terranix.org";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mrVanDalo ];
  };

}

