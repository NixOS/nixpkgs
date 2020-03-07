{ stdenv, fetchFromGitHub, termbox, pcre, uthash, lua5_3 }:

stdenv.mkDerivation rec {
  pname = "mle";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "mle";
    rev = "v${version}";
    sha256 = "16dbwfdd6sqqn7jfaxd5wdy8y9ghbihnz6bgn3xhqcww8rj1sia1";
  };

  # Fix location of Lua 5.3 header and library
  postPatch = ''
    substituteInPlace Makefile --replace "-llua5.3" "-llua";
    substituteInPlace mle.h    --replace "<lua5.3/" "<";
    patchShebangs tests/*
  '';

  buildInputs = [ termbox pcre uthash lua5_3 ];

  doCheck = true;

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Small, flexible terminal-based text editor";
    homepage = "https://github.com/adsr/mle";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ adsr ];
  };
}
