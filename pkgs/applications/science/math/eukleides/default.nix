{ lib, stdenv, fetchurl, bison, flex, makeWrapper, texinfo4, getopt, readline, texlive }:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "eukleides";
  version = "1.5.4";

  src = fetchurl {
    url = "http://www.eukleides.org/files/${pname}-${version}.tar.bz2";
    sha256 = "0s8cyh75hdj89v6kpm3z24i48yzpkr8qf0cwxbs9ijxj1i38ki0q";
  };

  patches = [
    # use $CC instead of hardcoded gcc
    ./use-CC.patch
    # allow PostScript transparency in epstopdf call
    ./gs-allowpstransparency.patch
  ];

  nativeBuildInputs = [ bison flex texinfo4 makeWrapper ];

  buildInputs = [ getopt readline ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace mktexlsr true

    substituteInPlace doc/Makefile \
      --replace ginstall-info install-info

    substituteInPlace Config \
      --replace '/usr/local' "$out" \
      --replace '$(SHARE_DIR)/texmf' "$tex"
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: eukleides_build/triangle.o:(.bss+0x28): multiple definition of `A';
  #     eukleides_build/quadrilateral.o:(.bss+0x18): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/euktoeps \
      --prefix PATH : ${lib.makeBinPath [ getopt ]}
  '';

  outputs = [ "out" "doc" "tex" ];

  passthru = {
    tlType = "run";
    # packages needed by euktoeps, euktopdf and eukleides.sty
    tlDeps = with texlive; [ collection-pstricks epstopdf iftex moreverb ];
    pkgs = [ finalAttrs.finalPackage.tex ];
  };

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
  };
})
