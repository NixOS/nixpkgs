{stdenv, fetchurl, wxGTK, utillinux, zlib }:

stdenv.mkDerivation rec {
  name = "comical-0.8";
  src = fetchurl {
    url = "mirror://sourceforge/comical/${name}.tar.gz";
    sha256 = "0b6527cc06b25a937041f1eb248d0fd881cf055362097036b939817f785ab85e";
  };
  buildInputs = [ wxGTK utillinux zlib ];
  preBuild="makeFlags=\"prefix=$out\"";

  patches = [ ./wxgtk-2.8.patch ];

  preInstall = "mkdir -pv $out/bin";

  meta = {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = http://comical.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
