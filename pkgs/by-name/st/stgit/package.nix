{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  makeWrapper,
  asciidoc,
  docbook_xsl,
  docbook_xml_dtd_45,
  xmlto,
  curl,
  git,
  perl,
  darwin,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "stgit";
  version = "2.4.12";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    hash = "sha256-fNQLdW5KFpYUBBmaUYYOmDym7OweXsDfD+uFl688zcY=";
  };
  cargoHash = "sha256-s3PFNc1rn01X6tauRXp5B4cg3AIVSishqDFy0lP/8g8=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    perl
  ];
  buildInputs = [ curl ];

  nativeCheckInputs =
    [
      git
      perl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.system_cmds
      libiconv
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
  installTargets = [
    "install"
    "install-man"
    "install-html"
  ];

  postInstall = ''
    wrapProgram $out/bin/stg --prefix PATH : ${lib.makeBinPath [ git ]}

    installShellCompletion --cmd stg \
      --fish completion/stg.fish \
      --bash completion/stgit.bash \
      --zsh completion/stgit.zsh
  '';

  meta = with lib; {
    description = "Patch manager implemented on top of Git";
    homepage = "https://stacked-git.github.io/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jshholland ];
    mainProgram = "stg";
  };
}
