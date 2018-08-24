{ stdenv, fetchurl, makeWrapper, python27Packages, git
, docbook_xml_dtd_412, docbook_xsl, asciidoc, xmlto, pypy
, bazaar ? null, cvs ? null, darcs ? null, fossil ? null
, mercurial ? null, monotone ? null, rcs ? null
, subversion ? null, cvs_fast_export ? null }:

with stdenv; with lib;
let
  inherit (python27Packages) python;
in mkDerivation rec {
  name = "reposurgeon-${meta.version}";
  meta = {
    description = "A tool for editing version-control repository history";
    version = "3.44";
    license = licenses.bsd3;
    homepage = http://www.catb.org/esr/reposurgeon/;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.44.tar.xz";
    sha256 = "0il6hwrsm2qgg0vp5fcjh478y2x4zyw3mx2apcwc7svfj86pf7pn";
  };

  # install fails because the files README.md, NEWS, and TODO were not included in the source distribution
  patches = [ ./fix-makefile.patch ];

  buildInputs =
    [ docbook_xml_dtd_412 docbook_xsl asciidoc xmlto makeWrapper pypy ];

  preBuild = ''
    makeFlagsArray=(
      XML_CATALOG_FILES="${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml ${docbook_xsl}/xml/xsl/docbook/catalog.xml"
      prefix="$out"
      pyinclude="-I${python}/include/python2.7"
      pylib="-L${python}/lib -lpython2.7"
    )
  '';

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
