{ lib, stdenv
, fetchurl
, makeWrapper

, alsaLib
, perl
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.26.5";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "sha256-UCqX4Nk1vn432YczgCHY8wG641wohPKoPVnEtSRm7wY=";
  };

  outputs = [ "out" "conplay" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ] ++ lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = lib.optional
    (stdenv.hostPlatform ? mpg123)
    "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  postInstall = ''
    mkdir -p $conplay/bin
    mv scripts/conplay $conplay/bin/
  '';

  preFixup = ''
    patchShebangs $conplay/bin/conplay
  '';

  postFixup = ''
    wrapProgram $conplay/bin/conplay \
      --prefix PATH : $out/bin
  '';

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "http://mpg123.org";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.ftrvxmtrx ];
    platforms = lib.platforms.unix;
  };
}
