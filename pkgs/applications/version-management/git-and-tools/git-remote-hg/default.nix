{ stdenv, fetchgit, mercurial, makeWrapper,
  asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libxml2
}:

stdenv.mkDerivation rec {
  rev = "e716a9e1a9e460a45663694ba4e9e8894a8452b2";
  version = "0.2-${rev}";
  name = "git-remote-hg-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/fingolfin/git-remote-hg.git";
    sha256 = "7c61c8f2be47d96c4244f0f8a3c8f9b994994b15dbe1754581f746888d705463";
  };

  buildInputs = [ mercurial.python mercurial makeWrapper
    asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt libxml2
  ];

  doCheck = false;

  installFlags = "HOME=\${out} install-doc";

  postInstall = ''
    wrapProgram $out/bin/git-remote-hg \
      --prefix PYTHONPATH : "$(echo ${mercurial}/lib/python*/site-packages):$(echo ${mercurial.python}/lib/python*/site-packages)${stdenv.lib.concatMapStrings (x: ":$(echo ${x}/lib/python*/site-packages)") mercurial.pythonPackages}"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/felipec/git-remote-hg";
    description = "semi-official Mercurial bridge from Git project, once installed, it allows you to clone, fetch and push to and from Mercurial repositories as if they were Git ones";
    license = licenses.gpl2;
    maintainers = [ maintainers.garbas ];
  };
}
