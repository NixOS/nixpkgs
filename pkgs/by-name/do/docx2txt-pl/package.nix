{
  lib,
  stdenv,
  fetchurl,
  perl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docx2txt-pl";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/docx2txt/docx2txt-${finalAttrs.version}.tgz";
    sha256 = "sha256-spd1KRCkBMFDXnA9Wu20VxIivXWfoxbIatjIu+WMbRs=";
  };

  buildInputs = [ perl ];

  dontBuild = true;

  patchPhase = ''
    substituteInPlace docx2txt.pl \
      --replace '/usr/bin/unzip' '${unzip}/bin/unzip'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp docx2txt.pl $out/bin/docx2txt
    chmod +x $out/bin/docx2txt
  '';

  meta = {
    description = "Perl-based docx2txt script (SourceForge version)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
