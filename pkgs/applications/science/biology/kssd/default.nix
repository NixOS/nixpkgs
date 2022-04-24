{ lib, stdenv, fetchFromGitHub, zlib, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  pname = "kssd";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "yhg926";
    repo = "public_kssd";
    rev = "v${version}";
    sha256 = "sha256-8jzYqo9LXF66pQ1EIusm+gba2VbTYpJz2K3NVlA3QxY=";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ zlib libtool ];

  installPhase = ''
      install -vD kssd $out/bin/kssd
  '';

  meta = with lib; {
    description = "K-mer substring space decomposition";
    license     = licenses.asl20;
    homepage    = "https://github.com/yhg926/public_kssd";
    maintainers = with maintainers; [ unode ];
    platforms = [ "x86_64-linux" ];
  };
}
