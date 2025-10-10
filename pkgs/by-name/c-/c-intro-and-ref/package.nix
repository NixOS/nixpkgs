{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  texinfo,
  texliveBasic,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "c-intro-and-ref";
  version = "0.1";

  src = fetchurl {
    url = "mirror://gnu/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-45mtnlyz2RuYUk4Jza+lZGGBxezpiRS/v70xx1iKxEQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    texinfo
    texliveBasic
  ];

  # Remove pre-built documentaton artifacts
  postConfigure = ''
    make clean
  '';

  buildFlags = [
    "c.dvi"
    "c.html"
  ];

  # Build missing targets
  postBuild = ''
    makeinfo --html --no-split c.texi -o c.htm
    makeinfo --plaintext c.texi -o c.txt
  '';

  # FIXME: Not a HASH reference at (texinfo)/share/texinfo/Texinfo/Convert/DocBook.pm
  # Occurs when building "c.doc"
  # makeinfo --docbook c.texi -o c.doc

  # Install missing targets
  postInstall = ''
    install -Dm644 c.htm $out/share/doc/c-intro-and-ref/c.html
    install -Dm644 c.txt -t $out/share/doc/c-intro-and-ref/
    install -Dm644 c.html/* -t $out/share/doc/c-intro-and-ref/c.html.d/
    install -Dm644 c.dvi -t $out/share/doc/c-intro-and-ref/
  '';

  meta = {
    description = "GNU C Language Intro and Reference Manual";
    longDescription = ''
      This manual explains the C language for use with the GNU Compiler
      Collection (GCC) on the GNU/Linux operating system and other systems. We
      refer to this dialect as GNU C. If you already know C, you can use this as
      a reference manual.
    '';
    homepage = "https://www.gnu.org/software/c-intro-and-ref/";
    license = lib.licenses.fdl13Plus;
    maintainers = with lib.maintainers; [
      normalcea
      rc-zb
    ];
    platforms = lib.platforms.all;
  };
})
