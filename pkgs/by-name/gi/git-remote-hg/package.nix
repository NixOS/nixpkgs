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
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mnauw";
    repo = "git-remote-hg";
    tag = "v${version}";
    hash = "sha256-QlXi5LQAYMNCF7ZjQdJxwcjp3K51dGkHVnNw0pgArzg=";
  };

  nativeBuildInputs = [
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    libxslt
    libxml2
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ mercurial ];

  postInstall = ''
    make install-doc prefix=$out
  '';

  meta = {
    homepage = "https://github.com/mnauw/git-remote-hg";
    description = "Semi-official Mercurial bridge from Git project";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
