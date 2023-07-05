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
}:

rustPlatform.buildRustPackage rec {
  pname = "stgit";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "sha256-pGGLY/Hu62dT3KP9GH9YmPg6hePDoPdijJtmap5gpEA=";
  };
  cargoHash = "sha256-f0MQvCkFYR7ErbBDJ3n0r9ZetKfcWg9twhc4r4EpPS4=";

  nativeBuildInputs = [
    pkg-config installShellFiles makeWrapper asciidoc xmlto docbook_xsl
    docbook_xml_dtd_45 perl
  ];
  buildInputs = [ curl ];

  nativeCheckInputs = [
    git perl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.system_cmds darwin.libiconv
  ];

  patches = [
    # Fixes tests, can be removed when stgit 2.3.1 is released
    ./0001-fix-use-canonical-Message-ID-spelling.patch
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

  makeFlags = lib.strings.concatStringsSep " " [
    "prefix=${placeholder "out"}"
    "MAN_BASE_URL=${placeholder "out"}/share/man"
    "XMLTO_EXTRA=--skip-validation"
    "PERL_PATH=${perl}/bin/perl"
  ];

  buildPhase = ''
    make all ${makeFlags}
  '';

  checkPhase = ''
    make test ${makeFlags}
  '';

  installPhase = ''
    make install install-man install-html ${makeFlags}

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
