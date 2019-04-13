{ stdenv, fetchFromGitHub, mercurial, python2Packages,
  asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libxml2
}:

python2Packages.buildPythonApplication rec {
  version = "1.0.0";
  pname = "git-remote-hg";

  # not using fetchPypi - the PyPI tarball does not include the manpage
  src = fetchFromGitHub {
    owner = "mnauw";
    repo = "git-remote-hg";
    rev = "v${version}";
    sha256 = "0anl054zdi5rg5m4bm1n763kbdjkpdws3c89c8w8m5gq1ifsbd4d";
  };

  nativeBuildInputs = [ asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt libxml2 ];
  propagatedBuildInputs = [ mercurial ];

  doCheck = false;

  patches = [
    ./patches/no-dynamic-git-version.patch
  ];

  postInstall = ''
    make "HOME=${placeholder "out"}" install-doc;
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mnauw/git-remote-hg;
    description = "Git remote helper for Mercurial repositories";
    license = licenses.gpl2;
    maintainers = [ maintainers.garbas ];
    platforms = platforms.unix;
  };
}
