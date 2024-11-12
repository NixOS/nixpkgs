{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "analog";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "c-amie";
    repo = "analog-ce";
    rev = version;
    sha256 = "sha256-NCturEibnpl6+paUZezksHzP33WtAzfIolvBLeEHXjY=";
  };

  postPatch = ''
    sed -i src/anlghead.h \
      -e "s|#define DEFAULTCONFIGFILE .*|#define DEFAULTCONFIGFILE \"$out/etc/analog.cfg\"|g" \
      -e "s|#define LANGDIR .*|#define LANGDIR \"$out/share/${pname}/lang/\"|g"
    substituteInPlace src/Makefile --replace "gcc" "${stdenv.cc.targetPrefix}cc"
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
