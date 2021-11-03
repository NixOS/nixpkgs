{ lib
, fetchFromGitHub
, installShellFiles
, python3Packages
, asciidoc
, docbook_xsl
, docbook_xml_dtd_45
, git
, perl
, xmlto
}:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "0yx81d61kp33h7n0c14wvcrh8vvjjjq4xjh1qwq2sdbmqc43p3hg";
  };

  nativeBuildInputs = [ installShellFiles asciidoc xmlto docbook_xsl docbook_xml_dtd_45 ];

  format = "other";

  checkInputs = [ git perl ];

  postPatch = ''
    for f in Documentation/*.xsl; do
      substituteInPlace $f \
        --replace http://docbook.sourceforge.net/release/xsl-ns/current/manpages/docbook.xsl \
                  ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl \
        --replace http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl \
                  ${docbook_xsl}/xml/xsl/docbook/html/docbook.xsl
    done

    substituteInPlace Documentation/texi.xsl \
      --replace http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd \
                ${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd

    cat > stgit/_version.py <<EOF
    __version__ = "${version}"
    EOF
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "MAN_BASE_URL=${placeholder "out"}/share/man"
    "XMLTO_EXTRA=--skip-validation"
  ];

  buildFlags = [ "all" "doc" ];

  checkTarget = "test";
  checkFlags = [ "PERL_PATH=${perl}/bin/perl" ];

  installTargets = [ "install" "install-doc" "install-html" ];
  postInstall = ''
    installShellCompletion --cmd stg \
      --fish completion/stg.fish \
      --bash completion/stgit.bash \
      --zsh completion/stgit.zsh
  '';

  meta = with lib; {
    description = "A patch manager implemented on top of Git";
    homepage = "https://stacked-git.github.io/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jshholland ];
  };
}
