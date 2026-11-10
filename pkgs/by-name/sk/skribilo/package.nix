{
  lib,
  stdenv,
  fetchurl,
  fig2dev,
  gettext,
  ghostscript,
  guile,
  guile-lib,
  guile-reader,
  imagemagick,
  makeWrapper,
  pkg-config,
  enableEmacs ? false,
  emacs,
  enableLout ? stdenv.hostPlatform.isLinux,
  lout,
  enablePloticus ? stdenv.hostPlatform.isLinux,
  ploticus,
  enableTex ? true,
  texliveSmall,
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "skribilo";
  version = "0.11.1";

  src = fetchurl {
    url = "mirror://savannah/skribilo/skribilo-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZlwkHEKSC/Np8SMdS5xxzhi6Y63QuajyQYIf0Roo1ZI=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fig2dev
    gettext
    ghostscript
    guile
    guile-lib
    guile-reader
    imagemagick
  ]
  ++ optional enableEmacs emacs
  ++ optional enableLout lout
  ++ optional enablePloticus ploticus
  ++ optional enableTex texliveSmall;

  postInstall = ''
    wrapProgram $out/bin/skribilo \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  meta = {
    homepage = "https://www.nongnu.org/skribilo/";
    description = "Ultimate Document Programming Framework";
    longDescription = ''
      Skribilo is a free document production tool that takes a structured
      document representation as its input and renders that document in a
      variety of output formats: HTML and Info for on-line browsing, and Lout
      and LaTeX for high-quality hard copies.

      The input document can use Skribilo's markup language to provide
      information about the document's structure, which is similar to HTML or
      LaTeX and does not require expertise. Alternatively, it can use a simpler,
      "markup-less" format that borrows from Emacs' outline mode and from other
      conventions used in emails, Usenet and text.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
