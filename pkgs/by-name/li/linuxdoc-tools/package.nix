{
  stdenv,
  lib,
  makeWrapper,
  fetchFromGitLab,
  perl,
  flex,
  gnused,
  coreutils,
  which,
  opensp,
  groff,
  texliveMedium,
  texinfo,
  withLatex ? false,
}:

stdenv.mkDerivation rec {
  pname = "linuxdoc-tools";
  version = "0.9.85";

  src = fetchFromGitLab {
    owner = "agmartin";
    repo = "linuxdoc-tools";
    rev = version;
    hash = "sha256-8nsCfcxqVt16br6Vhk8tW3cxJMJFSZYX2g3MjO7JoT4=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  configureFlags = [
    ("--enable-docs=txt info lyx html rtf" + lib.optionalString withLatex " pdf")
  ];

  LEX = "flex";

  postInstall = ''
    wrapProgram $out/bin/linuxdoc \
      --prefix PATH : "${
        lib.makeBinPath [
          groff
          opensp
        ]
      }:$out/bin" \
      --prefix PERL5LIB : "$out/share/linuxdoc-tools/"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    pushd doc/example
    substituteInPlace Makefile \
      --replace "COMMAND=linuxdoc" "COMMAND=$out/bin/linuxdoc" \
      ${lib.optionalString (!withLatex) "--replace '.tex .dvi .ps .pdf' ''"}
    make
    popd
  '';

  nativeBuildInputs = [
    flex
    which
    makeWrapper
  ];

  buildInputs = [
    opensp
    groff
    texinfo
    perl
    gnused
    coreutils
  ] ++ lib.optionals withLatex [ texliveMedium ];

  meta = with lib; {
    description = "Toolset for processing LinuxDoc DTD SGML files";
    longDescription = ''
      A collection of text formatters which understands a LinuxDoc DTD SGML
      source file. Each formatter (or "back-end") renders the source file into
      a variety of output formats, including HTML, TeX, DVI, PostScript, plain
      text, and groff source in manual-page format. The linuxdoc suite is
      provided for backward compatibility, because there are still many useful
      documents written in LinuxDoc DTD sgml source.
    '';
    homepage = "https://gitlab.com/agmartin/linuxdoc-tools";
    license = with licenses; [
      gpl3Plus
      mit
      sgmlug
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ p-h ];
  };
}
