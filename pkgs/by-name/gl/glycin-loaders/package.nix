{
  stdenv,
  lib,
  fetchurl,
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
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-OAqv4r+07KDEW0JmDr/0SWANAKQ7YJ1bHIP3lfXI+zw=";
  };

  cargoVendorDir = "vendor";

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
    "-Dlibglycin=false"
    "-Dvapi=false"
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace loaders/meson.build \
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
