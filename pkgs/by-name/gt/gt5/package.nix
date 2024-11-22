{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "gt5";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/gt5/gt5-${version}.tar.gz";
    sha256 = "0gm0gzyp4d9rxqddbaskbz5zvmlhyr4nyb5x9g7x4abyyxqjlnkq";
  };

  patchPhase = ''
    sed 's/-o root -g root//' -i Makefile
  '';

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';

  meta = {
    description = "Diff-capable 'du' browser";
    homepage = "https://gt5.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; all;
    mainProgram = "gt5";
  };
}
