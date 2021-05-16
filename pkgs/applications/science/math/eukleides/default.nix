{ lib, stdenv, fetchurl, bison, flex, makeWrapper, texinfo, readline, texLive }:

lib.fix (eukleides: stdenv.mkDerivation rec {
  pname = "eukleides";
  version = "1.5.4";

  src = fetchurl {
    url = "http://www.eukleides.org/files/${pname}-${version}.tar.bz2";
    sha256 = "0s8cyh75hdj89v6kpm3z24i48yzpkr8qf0cwxbs9ijxj1i38ki0q";
  };

  # use $CC instead of hardcoded gcc
  patches = [ ./use-CC.patch ];

  nativeBuildInputs = [ bison flex texinfo makeWrapper ];

  buildInputs = [ readline texLive ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace mktexlsr true

    substituteInPlace doc/Makefile \
      --replace ginstall-info install-info

    substituteInPlace Config \
      --replace '/usr/local' "$out" \
      --replace '$(SHARE_DIR)/texmf' "$tex"
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/euktoeps \
      --set-default TEXINPUTS : \
      --prefix TEXINPUTS : "$tex/tex/latex/eukleides" \
      --prefix PATH : "${texLive}/bin"
    wrapProgram $out/bin/euktopdf \
      --set-default TEXINPUTS : \
      --prefix TEXINPUTS : "$tex/tex/latex/eukleides" \
      --prefix PATH : "${texLive}/bin"
  '';

  outputs = [ "out" "doc" "tex" ];

  passthru.tlType = "run";
  passthru.pkgs = [ eukleides.tex ];

  meta = {
    description = "Geometry Drawing Language";
    homepage = "http://www.eukleides.org/";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Eukleides is a computer language devoted to elementary plane
      geometry. It aims to be a fairly comprehensive system to create
      geometric figures, either static or dynamic. Eukleides allows to
      handle basic types of data: numbers and strings, as well as
      geometric types of data: points, vectors, sets (of points), lines,
      circles and conics.
    '';

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
})
