{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "terranix";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "terranix";
    rev = version;
    sha256 = "sha256-3N4a5VhZqIgJW11w8oJKJ9T8mhfwEM33kEwV/zZkCs8=";
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

