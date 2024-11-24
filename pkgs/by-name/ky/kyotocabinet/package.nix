{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "kyotocabinet";
  version = "1.2.80";

  src = fetchurl {
    url = "https://dbmx.net/kyotocabinet/pkg/kyotocabinet-${version}.tar.gz";
    sha256 = "sha256-TIXXNmaNgpIL/b25KsPWa32xEI8JWBp2ndkWCgLe80k=";
  };

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace kccommon.h \
      --replace tr1/unordered_map unordered_map \
      --replace tr1/unordered_set unordered_set \
      --replace tr1::hash std::hash \
      --replace tr1::unordered_map std::unordered_map \
      --replace tr1::unordered_set std::unordered_set

    substituteInPlace lab/kcdict/Makefile --replace stdc++ c++
    substituteInPlace configure \
        --replace /usr/local/bin:/usr/local/sbin: "" \
        --replace /usr/bin:/usr/sbin: "" \
        --replace /bin:/sbin: "" \
        --replace stdc++ c++
  '';

  buildInputs = [ zlib ];

  meta = with lib; {
    homepage = "https://dbmx.net/kyotocabinet";
    description = "Library of routines for managing a database";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
