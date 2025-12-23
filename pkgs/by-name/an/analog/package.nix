{
  stdenv,
  lib,
  fetchFromGitHub,
  bzip2,
  gd,
  libjpeg,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "analog";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "c-amie";
    repo = "analog-ce";
    tag = version;
    sha256 = "sha256-NCturEibnpl6+paUZezksHzP33WtAzfIolvBLeEHXjY=";
  };

  buildInputs = [
    bzip2
    gd
    libjpeg
    libpng
  ];

  postPatch = ''
    sed -i src/anlghead.h \
      -e "s|#define DEFAULTCONFIGFILE .*|#define DEFAULTCONFIGFILE \"$out/etc/analog.cfg\"|g" \
      -e "s|#define LANGDIR .*|#define LANGDIR \"$out/share/${pname}/lang/\"|g"
    substituteInPlace src/Makefile \
      --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc" \
      --replace-fail "LIBS = -lm" "LIBS = -lm -lpng -lgd -ljpeg -lz -lbz2" \
      --replace-fail "DEFS =" "DEFS = -DHAVE_GD -DHAVE_ZLIB -DHAVE_BZLIB"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc $out/share/doc/$pname $out/share/man/man1 $out/share/$pname
    mv analog $out/bin/
    cp examples/big.cfg $out/etc/analog.cfg
    mv analog.man $out/share/man/man1/analog.1
    mv docs $out/share/doc/$pname/manual
    mv how-to $out/share/doc/$pname/
    mv lang images examples $out/share/$pname/
  '';

  meta = {
    homepage = "https://www.c-amie.co.uk/software/analog/";
    license = lib.licenses.gpl2Only;
    description = "Powerful tool to generate web server statistics";
    platforms = lib.platforms.all;
    mainProgram = "analog";
  };

}
