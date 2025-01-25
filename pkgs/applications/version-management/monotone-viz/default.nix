{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ocamlPackages,
  gnome2,
  pkg-config,
  makeWrapper,
  glib,
  libtool,
  libpng,
  bison,
  expat,
  fontconfig,
  gd,
  pango,
  libjpeg,
  libwebp,
  libX11,
  libXaw,
}:
# We need an old version of Graphviz for format compatibility reasons.
# This version is vulnerable, but monotone-viz will never feed it bad input.
let
  graphviz_2_0 = import ./graphviz-2.0.nix {
    inherit
      lib
      stdenv
      fetchurl
      pkg-config
      libX11
      libpng
      libjpeg
      expat
      libXaw
      bison
      libtool
      fontconfig
      pango
      gd
      libwebp
      ;
  };
in
let
  inherit (gnome2) libgnomecanvas;
in
let
  inherit (ocamlPackages) ocaml lablgtk camlp4;
in
stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "monotone-viz";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    ocaml
    camlp4
  ];
  buildInputs = [
    lablgtk
    libgnomecanvas
    glib
    graphviz_2_0
  ];
  src = fetchurl {
    url = "http://oandrieu.nerim.net/monotone-viz/${pname}-${version}-nolablgtk.tar.gz";
    sha256 = "1l5x4xqz5g1aaqbc1x80mg0yzkiah9ma9k9mivmn08alkjlakkdk";
  };

  prePatch = "ln -s . a; ln -s . b";
  patchFlags = [ "-p0" ];
  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/monotone-viz/raw/c9f4c1bebe01bb471df05d8a37ca4b6d630574ec/f/monotone-viz-1.0.2-dot.patch";
      hash = "sha256-e348703+IzM4m/3cpe6Z9VebZgTK8+3lRLdaTfXHwSI=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/monotone-viz/raw/c9f4c1bebe01bb471df05d8a37ca4b6d630574ec/f/monotone-viz-1.0.2-new-stdio.patch";
      hash = "sha256-9xQzJ+oYz06fDFOe1YOOisEZnwiwShqr2Rt7IXiu6Zo=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/monotone-viz/raw/c9f4c1bebe01bb471df05d8a37ca4b6d630574ec/f/monotone-viz-1.0.2-typefix.patch";
      hash = "sha256-52VGXDJKx4ZGvZRO8QCXdTGsWR0m1pqQnEOby7PMQdg=";
    })
  ];

  preConfigure = ''
    appendToVar configureFlags "--with-lablgtk-dir=$(echo ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2)"
  '';

  postInstall = ''
    wrapProgram "$out/bin/monotone-viz" --prefix PATH : "${graphviz_2_0}/bin/"
  '';

  meta = {
    description = "Monotone ancestry visualiser";
    mainProgram = "monotone-viz";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
