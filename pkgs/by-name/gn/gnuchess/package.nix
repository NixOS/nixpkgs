{
  lib,
  stdenv,
  fetchurl,
  flex,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "gnuchess";
  version = "6.3.0";

  src = fetchurl {
    url = "mirror://gnu/chess/gnuchess-${version}.tar.gz";
    sha256 = "sha256-Cze+wgmMKtaVt0Q+XXlE3G3IKE+NAfzDC9uU3QM8ojo=";
  };

  buildInputs = [
    flex
  ];
  nativeBuildInputs = [ makeWrapper ];

  configureFlags = [
    # register keyword is removed in c++17 so stick to c++14
    "CXXFLAGS=-std=c++14"
  ];

  postInstall = ''
    wrapProgram $out/bin/gnuchessx --set PATH "$out/bin"
    wrapProgram $out/bin/gnuchessu --set PATH "$out/bin"
  '';

  meta = with lib; {
    description = "GNU Chess engine";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
