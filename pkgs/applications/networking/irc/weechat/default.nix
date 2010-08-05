{stdenv, fetchurl, ncurses, openssl, perl, python, aspell}:

stdenv.mkDerivation {
  name = "weechat-0.3.2";

  src = fetchurl {
    url = http://weechat.org/files/src/weechat-0.3.2.tar.gz;
    sha256 = "0ds548fmiv2fg69amhyg1v1rgyw51rqlp64p3rmsbm1lkcwwmivc";
  };

  buildInputs = [ncurses perl python openssl aspell];

  meta = {
    homepage = http://http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
  };
}
     
