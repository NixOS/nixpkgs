{ stdenv, fetchgit, mercurial, makeWrapper,
  asciidoc, xmlto, dbus, docbook_xsl, docbook_xml_dtd_45, libxslt, libxml2
}:

stdenv.mkDerivation rec {
  rev = "185852eac44c25ae2e8d3b3fb6c9630e754e6363";
  version = "v0.2-185852eac44c25ae2e8d3b3fb6c9630e754e6363";
  name = "git-remote-hg-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/felipec/git-remote-hg.git";
    sha256 = "1hc65nvxq7if1imwffyxia0i6vnkbax09gfcl9vq9yffzi8xzzfy";
  };

  buildInputs = [ mercurial.python mercurial makeWrapper
    asciidoc xmlto dbus docbook_xsl docbook_xml_dtd_45 libxslt libxml2
  ];

  doCheck = false;

  installFlags = "HOME=\${out}";

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
