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
  common-updater-scripts,
  _experimental-update-script-combinators,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "2.0.7";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-xBasKbbT7NxnuQwVU3uhKTzrevlvoQHK5nt9HTflCrA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "glycin-loaders-deps-${finalAttrs.version}";
    hash = "sha256-UVVVjMt4vWkLob0H/MxIaW6rkBSFImu+5dezaCnc3Q8=";
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
    updateScript =
      let
        updateSource = gnome.updateScript {
          attrPath = "glycin-loaders";
          packageName = "glycin";
        };
        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version glycin-loaders --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
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
