{ stdenv, lib, fetchFromGitHub, mercurial, makeWrapper
, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libxml2
}:

stdenv.mkDerivation rec {
  pname = "git-remote-hg";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mnauw";
    repo = "git-remote-hg";
    rev = "v${version}";
    sha256 = "1by5ygqvq9ww990kdrjndaqsssyf2jc4n380f9pfh2avsr7871wc";
  };

  buildInputs = [ mercurial.python mercurial makeWrapper
    asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt libxml2
  ];

  doCheck = false;

  installFlags = [ "HOME=\${out}" "install-doc" ];

  postInstall = ''
    wrapProgram $out/bin/git-remote-hg \
      --prefix PYTHONPATH : "$(echo ${mercurial}/lib/python*/site-packages):$(echo ${mercurial.python}/lib/python*/site-packages)${stdenv.lib.concatMapStrings (x: ":$(echo ${x}/lib/python*/site-packages)") mercurial.pythonPackages or []}"
  '';

  meta = with lib; {
    homepage = https://github.com/mnauw/git-remote-hg;
    description = "Semi-official Mercurial bridge from Git project";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
