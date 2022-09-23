{ lib, stdenv, fetchurl, wxGTK, util-linux, zlib }:

stdenv.mkDerivation rec {
  pname = "comical";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/comical/comical-${version}.tar.gz";
    sha256 = "0b6527cc06b25a937041f1eb248d0fd881cf055362097036b939817f785ab85e";
  };

  buildInputs = [ wxGTK util-linux zlib ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  patches = [ ./wxgtk-2.8.patch ];

  preInstall = "mkdir -pv $out/bin";

  meta = {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = "http://comical.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
