{ lib
, fetchFromGitHub
, installShellFiles
, python3Packages
, asciidoc
, docbook_xsl
, git
, perl
, xmlto
}:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "sha256-gfPf1yRmx1Mn1TyCBWmjQJBgXLlZrDcew32C9o6uNYk=";
  };

  nativeBuildInputs = [ installShellFiles asciidoc xmlto docbook_xsl ];

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
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "MAN_BASE_URL=${placeholder "out"}/share/man"
    "XMLTO_EXTRA=--skip-validation"
  ];

  buildFlags = [ "all" "doc" ];

  checkTarget = "test";
  checkFlags = [ "PERL_PATH=${perl}/bin/perl" ];

  installTargets = [ "install" "install-doc" ];
  postInstall = ''
    installShellCompletion --cmd stg \
      --fish $out/share/stgit/completion/stg.fish \
      --bash $out/share/stgit/completion/stgit.bash \
      --zsh $out/share/stgit/completion/stgit.zsh
    '';

  meta = with lib; {
    description = "A patch manager implemented on top of Git";
    homepage = "https://stacked-git.github.io/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jshholland ];
  };
}
