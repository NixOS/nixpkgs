{ stdenv, fetchurl, makeWrapper, python27Packages, git
, docbook_xml_dtd_412, docbook_xml_xslt, asciidoc, xmlto
, bazaar ? null, cvs ? null, darcs ? null, fossil ? null
, mercurial ? null, monotone ? null, rcs ? null, src ? null
, subversion ? null, cvs_fast_export ? null }:

with stdenv; with lib;
let
  inherit (python27Packages) python cython;
in mkDerivation rec {
  name = "reposurgeon-${meta.version}";
  meta = {
    description = "A tool for editing version-control repository history";
    version = "3.28";
    license = licenses.bsd3;
    homepage = http://www.catb.org/esr/reposurgeon/;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.28.tar.gz";
    sha256 = "3225b44109b8630310a0ea6fe63a3485d27aa46deaf80e8d07820e01a6f62626";
  };

  # See https://gitlab.com/esr/reposurgeon/issues/17
  patches = [ ./fix-preserve-type.patch ];  

  buildInputs =
    [ docbook_xml_dtd_412 docbook_xml_xslt asciidoc xmlto makeWrapper ] ++
    optional (cython != null) cython
  ;

  preBuild = ''
    makeFlagsArray=(
      XML_CATALOG_FILES="${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml ${docbook_xml_xslt}/xml/xsl/docbook/catalog.xml"
      prefix="$out"
      pyinclude="-I${python}/include/python2.7"
      pylib="-L${python}/lib -lpython2.7"
    )
  '';

  buildFlags = "all" + (if cython != null then " cyreposurgeon" else "");

  installTargets =
    "install" + (if cython != null then " install-cyreposurgeon" else "")
  ;

  postInstall =
    let
      binpath = makeBinPath (
        filter (x: x != null)
        [ out git bazaar cvs darcs fossil mercurial
          monotone rcs src subversion cvs_fast_export ]
      );
      pythonpath = makeSearchPathOutput "lib" python.sitePackages (
        filter (x: x != null)
        [ python27Packages.readline or null python27Packages.hglib or null ]
      );
    in ''
      for prog in reposurgeon repodiffer repotool; do
        wrapProgram $out/bin/$prog \
          --prefix PATH : "${binpath}" \
          --prefix PYTHONPATH : "${pythonpath}"
      done
    ''
  ;    
}
