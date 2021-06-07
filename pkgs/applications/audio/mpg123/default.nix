{ lib, stdenv
, fetchurl
, makeWrapper
, alsaLib
, perl
, withConplay ? !stdenv.targetPlatform.isWindows
}:

stdenv.mkDerivation rec {
  name = "mpg123-1.26.5";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/${name}.tar.bz2";
    sha256 = "sha256-UCqX4Nk1vn432YczgCHY8wG641wohPKoPVnEtSRm7wY=";
  };

  outputs = [ "out" ] ++ lib.optionals withConplay [ "conplay" ];

  nativeBuildInputs = lib.optionals withConplay [ makeWrapper ];

  buildInputs = lib.optionals withConplay [ perl ]
    ++ lib.optionals (!stdenv.isDarwin && !stdenv.targetPlatform.isWindows) [ alsaLib ];

  configureFlags = lib.optional
    (stdenv.hostPlatform ? mpg123)
    "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  postInstall = lib.optionalString withConplay ''
    mkdir -p $conplay/bin
    mv scripts/conplay $conplay/bin/
  '';

  preFixup = lib.optionalString withConplay ''
    patchShebangs $conplay/bin/conplay
  '';

  postFixup = lib.optionalString withConplay ''
    wrapProgram $conplay/bin/conplay \
      --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "https://mpg123.org";
    license = licenses.lgpl21;
    maintainers = [ maintainers.ftrvxmtrx ];
    platforms = platforms.all;
  };
}
