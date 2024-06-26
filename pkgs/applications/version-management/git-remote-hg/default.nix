{
  lib,
  fetchFromGitHub,
  python3Packages,
  asciidoc,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_45,
  libxslt,
  libxml2,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-remote-hg";
  version = "1.0.3.2";

  src = fetchFromGitHub {
    owner = "mnauw";
    repo = "git-remote-hg";
    rev = "v${version}";
    sha256 = "0b5lfbrcrvzpz380817md00lbgy5yl4y76vs3vm0bpm5wmr7c027";
  };

  nativeBuildInputs = [
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    libxslt
    libxml2
  ];
  propagatedBuildInputs = with python3Packages; [ mercurial ];

  postInstall = ''
    make install-doc prefix=$out
  '';

  meta = with lib; {
    homepage = "https://github.com/mnauw/git-remote-hg";
    description = "Semi-official Mercurial bridge from Git project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
