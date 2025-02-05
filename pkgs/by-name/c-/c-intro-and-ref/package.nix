{
  lib,
  stdenv,
  fetchFromSavannah,
  texinfo,
  texliveBasic,
  ghostscript,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "c-intro-and-ref";
  version = "0.0-unstable-2024-08-31";

  src = fetchFromSavannah {
    repo = "c-intro-and-ref";
    rev = "62962013107481127176ef04d69826e41f51313c";
    hash = "sha256-Fmli3x8zvPntvCvV/wbEkxWzW9uDMZgCElPkKo9TS6Y=";
  };

  nativeBuildInputs = [
    texinfo
    ghostscript
    texliveBasic
  ];

  buildFlags = [
    "c.info"
    "c.dvi"
    "c.pdf"
    # FIXME: Not a HASH reference at (texinfo)/share/texinfo/Texinfo/Convert/DocBook.pm
    # "c.doc"
    "c.html"
    "c.html.d"
    "c.txt"
  ];

  installPhase = ''
    runHook preInstall
    dst_info=$out/share/info
    dst_doc=$out/share/doc/c-intro-and-ref
    mkdir -p $dst_info
    mkdir -p $dst_doc

    cp -prv -t $dst_info \
        c.info c.info-*
    cp -prv -t $dst_doc \
        c.dvi \
        c.pdf \
        c.html \
        c.html.d \
        c.txt
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "GNU C Language Intro and Reference Manual";
    longDescription = ''
      This manual explains the C language for use with the GNU Compiler
      Collection (GCC) on the GNU/Linux operating system and other systems. We
      refer to this dialect as GNU C. If you already know C, you can use this as
      a reference manual.
    '';
    homepage = "https://www.gnu.org/software/c-intro-and-ref/";
    changelog = "https://git.savannah.nongnu.org/cgit/c-intro-and-ref.git/plain/ChangeLog?id=${finalAttrs.src.rev}";
    license = lib.licenses.fdl13Plus;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})
