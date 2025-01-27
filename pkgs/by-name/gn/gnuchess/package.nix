{
  lib,
  stdenv,
  fetchurl,
  flex,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "gnuchess";
  version = "6.2.9";

  src = fetchurl {
    url = "mirror://gnu/chess/gnuchess-${version}.tar.gz";
    sha256 = "sha256-3fzCC911aQCpq2xCx9r5CiiTv38ZzjR0IM42uuvEGJA=";
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
