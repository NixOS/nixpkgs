{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  python3,
  rustPlatform,
  vala,
  gi-docgen,
  gobject-introspection,
  libseccomp,
  lcms2,
  gtk4,
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
  version = "2.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "glycin";
    tag = finalAttrs.version;
    hash = "sha256-17ebdiLMuDJuuw8TBYWamyyDM4aZgtWRWEQhWGb/2mw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    python3
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals withIntrospection [
    vala
    gi-docgen
    gobject-introspection
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-7x4Ts0wRFoxZ2u3AHVEey8g6+XWDpxM/hFZeomkojKU=";
  };

  buildInputs = [
    libseccomp
    lcms2
    gtk4
  ];

  propagatedBuildInputs = [
    libseccomp
    lcms2
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" true)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "capi_docs" withIntrospection)
  ];

  postPatch = ''
    patch -p2 < ${finalAttrs.passthru.glycin3PathsPatch}

    patchShebangs \
      build-aux/crates-version.py
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

    glycin3PathsPatch = replaceVars ./fix-glycin-3-paths.patch {
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
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "glycin-1"
      "glycin-gtk4-1"
    ];
  };
})
