{ stdenv, lib, fetchFromGitHub, linux-pam }:

stdenv.mkDerivation rec { 
  pname = "ly";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cylgom";
    repo = "ly";
    rev = version;
    sha256 = "16gjcrd4a6i4x8q8iwlgdildm7cpdsja8z22pf2izdm6rwfki97d";
    fetchSubmodules = true;
  }; 

  buildInputs = [ linux-pam ];
  makeFlags = [ "FLAGS=-Wno-error" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin 
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/cylgom/ly";
    maintainers = [ maintainers.spacekookie ];
  };
}
