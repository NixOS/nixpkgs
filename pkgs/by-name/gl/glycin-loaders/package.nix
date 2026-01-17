{
  stdenv,
  lib,
  cairo,
  cargo,
  gettext,
  glib,
  gtk4,
  libglycin,
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

  inherit (libglycin) version src cargoDeps;

  nativeBuildInputs = [
    cargo
    gettext # for msgfmt
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
