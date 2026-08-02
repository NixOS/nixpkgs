{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  parallel,
  sassc,
  inkscape,
  libxml2,
  glib,
  gdk-pixbuf,
  librsvg,
  gnome-shell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adapta-gtk-theme";
  version = "3.95.0.11";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    tag = finalAttrs.version;
    sha256 = "19skrhp10xx07hbd0lr3d619vj2im35d8p9rmb4v4zacci804q04";
  };

  patches = [
    ./disable-gtk2.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
    gnome-shell
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  postPatch = ''
    substituteInPlace gtk/Makefile.am \
      --replace-fail "--jobs 100%" '--jobs ''${NIX_BUILD_CORES}'

    patchShebangs .
  '';

  configureFlags = [
    "--disable-gtk_next"
    "--enable-parallel"
  ];

  meta = {
    description = "Adaptive GTK theme based on Material Design Guidelines";
    homepage = "https://github.com/adapta-project/adapta-gtk-theme";
    license = with lib.licenses; [
      gpl2
      cc-by-sa-30
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
