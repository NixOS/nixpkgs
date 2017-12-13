{ stdenv, fetchFromGitHub, cmake, qtbase, qtdeclarative, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "telegram-qt-unstable-${version}";
  version = "2017-11-12";

  src = fetchFromGitHub {
    owner = "Kaffeine";
    repo = "telegram-qt";
    rev = "71c722f05983883b30f9f6ae7aa8e39d0b514c10";
    sha256 = "1d21pi67a6347117w9pqqrzgyahhxmp3ri4yacn7dny2pb4pwqmb";
  };

  buildInputs = [ qtbase qtdeclarative openssl zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = " Qt-based library for Telegram network";
    homepage = src.meta.homepage;
    license = licenses.lgpl21;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
