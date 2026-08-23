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

  __structuredAttrs = true;
  strictDeps = true;

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
    license =
      with lib.licenses;
      # cc-by-sa-40 (svg files) is technically incompatible with gpl2 (everything else),
      # but cc-by-sa-40 is compatible with gpl3, which this project used to be licensed
      # under at some point. The intent behind this exact license combination is effectively
      # lost to time, as more than 700 issues have been made inaccessible even prior to the
      # repository's archival. At the very least we know it's not `OR [ gpl2 cc-by-sa-40 ]`
      # based on the README.md and the svg sources (which say cc-by-sa-40 in their xml).
      AND [
        gpl2
        cc-by-sa-40
      ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      romildo
      emilylange
    ];
  };
})
