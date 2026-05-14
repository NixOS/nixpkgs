{
  lib,
  stdenv,
  fetchurl,
  makeSetupHook,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  python3,
  rustPlatform,
  vala,
  gi-docgen,
  glib,
  gobject-introspection,
  glycin-loaders,
  libglycin-gtk4,
  fontconfig,
  libseccomp,
  lcms2,
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
  version = "2.0.8";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  setupHook = ./path-hook.sh;

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-a5rvT2Jr+Wnf0EtWO4PVIScaMMPW32pqhGP9VUkIkd8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-k3eHWdEUPjKuWqNaEAYjAQKvYFgCnZ+5laYujqgGrpQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    python3
    rustPlatform.cargoSetupHook
    finalAttrs.passthru.patchVendorHook
  ]
  ++ lib.optionals withIntrospection [
    vala
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    fontconfig
    libseccomp
    lcms2
  ];

  propagatedBuildInputs = [
    glib
    # TODO: these should not be required by .pc file
    fontconfig
    libseccomp
    lcms2
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" true)
    (lib.mesonBool "libglycin-gtk4" false)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "capi_docs" withIntrospection)
  ];

  postPatch = ''
    patchShebangs \
      build-aux/crates-version.py
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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

    patchVendorHook =
      makeSetupHook
        {
          name = "glycinPatchVendorHook";
        }
        (
          replaceVars ./patch-vendor-hook.sh {
            bwrap = "${bubblewrap}/bin/bwrap";
            jq = "${buildPackages.jq}/bin/jq";
            sponge = "${buildPackages.moreutils}/bin/sponge";
          }
        );

    tests = {
      inherit
        glycin-loaders
        libglycin-gtk4
        ;
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
    maintainers = [ ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "glycin-1"
    ];
  };
})
