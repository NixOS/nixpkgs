{ lib, stdenv, fetchurl, makeWrapper, asciidoc, docbook_xml_dtd_45, docbook_xsl
, coreutils, cvs, diffutils, findutils, git, python3, rsync
}:

stdenv.mkDerivation rec {
  pname = "cvs-fast-export";
<<<<<<< HEAD
  version = "1.61";

  src = fetchurl {
    url = "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-${version}.tar.gz";
    sha256 = "sha256-4iH8VKxVliVZKwZ40rGMb3fH1nxTBdMT5IcBzdp1mjw=";
=======
  version = "1.59";

  src = fetchurl {
    url = "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-${version}.tar.gz";
    sha256 = "sha256-JDnNg/VMmPJI6F07o77L4ChYDollLFB1YCL75WSp6No=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper asciidoc ];
  buildInputs = [ python3 ];

  postPatch = ''
    patchShebangs .
  '';

  preBuild = ''
    makeFlagsArray=(
      XML_CATALOG_FILES="${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml ${docbook_xsl}/xml/xsl/docbook/catalog.xml"
      LIBS=""
      prefix="$out"
    )
  '';

  postInstall = ''
    wrapProgram $out/bin/cvssync --prefix PATH : ${lib.makeBinPath [ rsync ]}
    wrapProgram $out/bin/cvsconvert --prefix PATH : $out/bin:${lib.makeBinPath [
      coreutils cvs diffutils findutils git
    ]}
  '';

  meta = with lib; {
    description = "Export an RCS or CVS history as a fast-import stream";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dfoxfranke ];
    homepage = "http://www.catb.org/esr/cvs-fast-export/";
    platforms = platforms.unix;
  };
}
