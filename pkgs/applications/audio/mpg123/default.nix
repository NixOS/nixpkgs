{ stdenv
, fetchurl
, makeWrapper

, alsaLib
, perl
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.25.13";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "02l915jq0ymndb082g6w89bpf66z04ifa1lr7ga3yycw6m46hc4h";
  };

  outputs = [ "out" "conplay" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ] ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = stdenv.lib.optional
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
    homepage = http://mpg123.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
    platforms = stdenv.lib.platforms.unix;
  };
}
