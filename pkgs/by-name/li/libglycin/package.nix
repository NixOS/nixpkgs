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
  replaceVars,
  bubblewrap,
  common-updater-scripts,
  _experimental-update-script-combinators,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin";
  version = "1.2.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "glycin";
    tag = finalAttrs.version;
    hash = "sha256-O7Z7kzC0BU7FAF1UZC6LbXVIXPDertsAUNYwHAjkzPI=";
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
    hash = "sha256-g2tsQ6q+sUxn3itu3IgZ5EGtDorPzhaO5B1hlEW5xzs=";
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

  postPatch = ''
    patch -p2 < ${finalAttrs.passthru.glycinPathsPatch}
  '';

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

    glycinPathsPatch = replaceVars ./fix-glycin-paths.patch {
      bwrap = "${bubblewrap}/bin/bwrap";
    };
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
