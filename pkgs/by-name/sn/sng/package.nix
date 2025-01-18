{
  lib,
  asciidoctor,
  fetchurl,
  libpng,
  netpbm,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sng";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/sng/sng-${finalAttrs.version}.tar.xz";
    hash = "sha256-yb37gPWhfbGquTN7rtZKjr6lwN34KRXGiHuM+4fs5h4=";
  };

  nativeBuildInputs = [ asciidoctor ];

  buildInputs = [ libpng ];

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "prefix=$(out)"
    "MANDIR=$(outputMan)/share/man"
    "RGBTXT=${netpbm.out}/share/netpbm/misc/rgb.txt"
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://sng.sourceforge.net/";
    description = "Minilanguage designed to represent the entire contents of a PNG file in an editable form";
    license = licenses.zlib;
    mainProgram = "sng";
    maintainers = with maintainers; [
      dezgeg
      AndersonTorres
    ];
    platforms = platforms.unix;
  };
})
