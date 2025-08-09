{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  rustPlatform,
  vala,
  gi-docgen,
  libseccomp,
  lcms2,
  gtk4,
  gobject-introspection,
  gnome,
  common-updater-scripts,
  _experimental-update-script-combinators,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin";
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "glycin";
    tag = finalAttrs.version;
    hash = "sha256-K+cR+0a/zRpOvMsX1ZljjJYYOXbHkyDGE9Q9vY1qJBg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals withIntrospection [
    vala
    gi-docgen
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zGDmmRbaR2boaf9lLzvW/H7xgMo9uHTmlC0oNupLUos=";
  };

  buildInputs = [
    libseccomp
    lcms2
    gtk4
  ]
  ++ lib.optionals withIntrospection [ gobject-introspection ];

  propagatedBuildInputs = [
    libseccomp
    lcms2
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "libglycin" true)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "capi_docs" withIntrospection)
  ];

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          attrPath = "libglycin";
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
              update-source-version libglycin --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
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

  meta = {
    description = "Sandboxed and extendable image loading library";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    changelog = "https://gitlab.gnome.org/GNOME/glycin/-/tags/${finalAttrs.version}";
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "glycin-1"
      "glycin-gtk4-1"
    ];
  };
})
