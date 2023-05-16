{ stdenv
, lib
<<<<<<< HEAD
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
=======
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
  version = "1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-TsJr2Riygz/DZrn6UZMPvq1tTfvl3dFEZZNq2wVj1Nw=";
  };

  nativeBuildInputs = [ installShellFiles asciidoc xmlto docbook_xsl docbook_xml_dtd_45 python3Packages.setuptools ];

  format = "other";

  nativeCheckInputs = [ git perl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======

    cat > stgit/_version.py <<EOF
    __version__ = "${version}"
    EOF
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
<<<<<<< HEAD
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

=======
    "MAN_BASE_URL=${placeholder "out"}/share/man"
    "XMLTO_EXTRA=--skip-validation"
  ];

  buildFlags = [ "all" "doc" ];

  checkTarget = "test";
  checkFlags = [ "PERL_PATH=${perl}/bin/perl" ];

  installTargets = [ "install" "install-doc" "install-html" ];
  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
