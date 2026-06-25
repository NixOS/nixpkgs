{
  fetchFromGitHub,
  glib,
  goocanvas2,
  gnucap,
  groff,
  gtk3,
  gtksourceview3,
  intltool,
  libxml2,
  lib,
  makeWrapper,
  ngspice,
  perl,
  pkg-config,
  python3,
  stdenv,
  wafHook,
  wrapGAppsHook,
  useNgspice ? false,
}:
let
  version = "0.84.43";
in
stdenv.mkDerivation {
  pname = "oregano";
  inherit version;

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = "oregano";
    tag = "v${version}";
    hash = "sha256-1GsL0N3O0clqdgkXoPKMhvW+y4Rzg4QSeOA54nH4kz4=";
  };

  patches = [
    ./check-cfg-gio-unix.patch
    ./fix-selection_changed-type-mismatch.patch
  ];

  buildInputs = [
    glib
    goocanvas2
    gtk3
    gtksourceview3
    libxml2
  ];

  nativeBuildInputs = [
    groff
    intltool
    makeWrapper
    wafHook
    perl
    pkg-config
    python3
    wrapGAppsHook
  ];

  # Force nixpkgs version of waf
  postPatch = ''
    rm waf
  '';

  postFixup = ''
    wrapProgram $out/bin/oregano \
      --suffix PATH : ${lib.makeBinPath [ (if useNgspice then ngspice else gnucap) ]}
  '';

  meta = {
    description = "Schematic capture and circuit simulator";
    longDescription = ''
      Oregano is an application for schematic capture and simulation of
      electronic circuits. The actual simulation is performed by Berkeley
      Spice, GNUcap or the new generation ngspice.
    '';

    homepage = "https://github.com/drahnr/oregano/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _3442 ];
  };
}
