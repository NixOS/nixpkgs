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
  python3,
  shared-mime-info,
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
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    python3
    # Tests use Rust glycin library.
    libglycin.patchVendorHook
  ];

  buildInputs = [
    cairo
    libheif
    libxml2 # for librsvg crate
    librsvg
    libseccomp
    libjxl
  ];

  # Tests in passthru.tests to avoid dependency cycles.
  checkInputs = [
    glib
    gtk4
    lcms2
  ];

  mesonFlags = [
    "-Dglycin-loaders=true"
    "-Dglycin-thumbnailer=false"
    "-Dlibglycin=false"
    "-Dlibglycin-gtk4=false"
    "-Dvapi=false"
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace glycin-loaders/meson.build \
      --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    chmod +x build-aux/setup-integration-test.py

    patchShebangs \
      build-aux/setup-integration-test.py
  '';

  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    # Fix test files being considered application/octet-stream
    export XDG_DATA_DIRS=${shared-mime-info}/share:$XDG_DATA_DIRS

    # fonts test will not be able to create cache without this
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    tests = {
      withTests = finalAttrs.finalPackage.overrideAttrs {
        doCheck = true;
      };
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
