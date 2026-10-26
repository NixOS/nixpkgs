{
  lib,
  stdenv,
  fetchurl,
  python3,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eweb";
  version = "9.10";

  src = fetchurl {
    url = "mirror://sourceforge/project/eweb/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    sha256 = "1xy7vm2sj5q6s620fm25klmnwnz9xkrxmx4q2f8h6c85ydisayd5";
  };

  buildInputs = [
    python3
    asciidoc
  ];

  installPhase = ''
    install -d $out/bin $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    cp etangle.py $out/bin
    cp etangle.w etangle.html $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
  '';

  meta = {
    homepage = "https://eweb.sourceforge.net/";
    description = "Asciidoc-based literate programming tool, written in Python";
    mainProgram = "etangle.py";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
