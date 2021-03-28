{ lib, fetchFromGitHub, python3Packages
, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libxml2
}:

python3Packages.buildPythonApplication rec {
  pname = "git-remote-hg";
  version = "unstable-2020-06-12";

  src = fetchFromGitHub {
    owner = "mnauw";
    repo = "git-remote-hg";
    rev = "28ed63b707919734d230cb13bff7d231dfeee8fc";
    sha256 = "0dw48vbnk7pp0w6fzgl29mq8fyn52pacbya2w14z9c6jfvh5sha1";
  };

  nativeBuildInputs = [
    asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt libxml2
  ];
  propagatedBuildInputs = with python3Packages; [ mercurial ];

  postInstall = ''
    make install-doc prefix=$out
  '';

  meta = with lib; {
    homepage = "https://github.com/mnauw/git-remote-hg";
    description = "Semi-official Mercurial bridge from Git project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
