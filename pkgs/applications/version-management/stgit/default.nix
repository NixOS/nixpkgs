{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, makeWrapper
, asciidoc
, docbook_xsl
, docbook_xml_dtd_45
, xmlto
, curl
, git
, perl
, darwin
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "stgit";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    hash = "sha256-rQNX54zmVHZKplEUNaKyVtCrC8Q4DdxLzNSStiYvDGA=";
  };
  cargoHash = "sha256-ju8JQnohidBsydwwm6gNx1L24brmDWYXwNgfCl7G/aA=";

  nativeBuildInputs = [
    pkg-config installShellFiles makeWrapper asciidoc xmlto docbook_xsl
    docbook_xml_dtd_45 perl
  ];
  buildInputs = [ curl ];

  nativeCheckInputs = [
    git perl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.system_cmds libiconv
  ];

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
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "XMLTO_EXTRA=--skip-validation"
    "PERL_PATH=${perl}/bin/perl"
  ];

  dontCargoBuild = true;
  buildFlags = [ "all" ];

  dontCargoCheck = true;
  checkTarget = "test";

  dontCargoInstall = true;
  installTargets = [ "install" "install-man" "install-html" ];

  postInstall = ''
    wrapProgram $out/bin/stg --prefix PATH : ${lib.makeBinPath [ git ]}

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
