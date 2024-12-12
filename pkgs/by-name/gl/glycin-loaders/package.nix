{
  stdenv,
  lib,
  fetchurl,
  bubblewrap,
  cairo,
  cargo,
  gettext,
  git,
  gnome,
  gtk4,
  jq,
  lcms2,
  libheif,
  libjxl,
  librsvg,
  libseccomp,
  libxml2,
  meson,
  moreutils,
  ninja,
  pkg-config,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "1.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-OAqv4r+07KDEW0JmDr/0SWANAKQ7YJ1bHIP3lfXI+zw=";
  };

  nativeBuildInputs = [
    cargo
    gettext # for msgfmt
    git
    meson
    ninja
    pkg-config
    rustc
  ];

  # Required for setup hook
  propagatedNativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [
    gtk4 # for GdkTexture
    cairo
    lcms2
    libheif
    libxml2 # for librsvg crate
    librsvg
    libseccomp
    libjxl
  ];

  mesonFlags = [
    "-Dglycin-loaders=true"
    "-Dlibglycin=false"
    "-Dvapi=false"
  ];

  strictDeps = true;

  setupHook = ./hook.sh;

  env = {
    bwrap = lib.getExe bubblewrap;
  };

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "glycin-loaders";
      packageName = "glycin";
    };
  };

  meta = {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    teams = [ lib.teams.gnome ];
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
