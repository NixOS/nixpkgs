{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  bubblewrap,
  cairo,
  cargo,
  gettext,
  git,
  gnome,
  gtk4,
  lcms2,
  libheif,
  libjxl,
  librsvg,
  libseccomp,
  libxml2,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "2.0.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-mkREIVtD1b2YUyW0CK4lC0S4Arb/SeGvCCXXAAi5Zz8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "glycin-loaders-deps-${finalAttrs.version}";
    hash = "sha256-omxOAZggqBzMKKg6NP8BnjnGwqIkn0fbOI3Vfwa+j1A=";
    dontConfigure = true;
  };

  nativeBuildInputs = [
    cargo
    gettext # for msgfmt
    git
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
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
    "-Dglycin-thumbnailer=false"
    "-Dlibglycin=false"
    "-Dlibglycin-gtk4=false"
    "-Dvapi=false"
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace glycin-loaders/meson.build \
      --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "glycin-loaders";
      packageName = "glycin";
    };
  };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    teams = [ teams.gnome ];
    license = with licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    platforms = platforms.linux;
  };
})
