{
  lib,
  _experimental-update-script-combinators,
  curl,
  duktape,
  fetchFromGitHub,
  gi-docgen,
  gitUpdater,
  glib,
  gobject-introspection,
  gsettings-desktop-schemas,
  makeHardcodeGsettingsPatch,
  meson,
  ninja,
  pkg-config,
  stdenv,
  replaceVars,
  vala,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libproxy";
  version = "0.5.11";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withIntrospection [
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = finalAttrs.version;
    hash = "sha256-CSI6GrTDBoYR6RFAQvgNjwzkMk8oXatEMpsv5FYB5eE=";
  };

  patches = [
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # Disable schema presence detection, it would fail because it cannot be autopatched,
    # and it will be hardcoded by the next patch anyway.
    ./skip-gsettings-detection.patch

    # Hardcode path to Settings schemas for GNOME & related desktops.
    # Otherwise every app using libproxy would need to be wrapped individually.
    (replaceVars ./hardcode-gsettings.patch {
      gds = glib.getSchemaPath gsettings-desktop-schemas;
    })
  ];

  postPatch = ''
    # Fix running script that will try to install git hooks.
    # Though it will not do anything since we do not keep .git/ directory.
    # https://github.com/libproxy/libproxy/issues/262
    chmod +x data/install-git-hook.sh
    patchShebangs data/install-git-hook.sh

    # Fix include-path propagation in non-static builds.
    # https://github.com/libproxy/libproxy/pull/239#issuecomment-2056620246
    substituteInPlace src/libproxy/meson.build \
      --replace-fail "requires_private: 'gobject-2.0'" "requires: 'gobject-2.0'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    curl
    duktape
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    glib
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    # Prevent installing commit hook.
    "-Drelease=true"
    (lib.mesonBool "docs" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Dconfig-gnome=false"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    hardcodeGsettingsPatch = makeHardcodeGsettingsPatch {
      schemaIdToVariableMapping = {
        "org.gnome.system.proxy" = "gds";
        "org.gnome.system.proxy.http" = "gds";
        "org.gnome.system.proxy.https" = "gds";
        "org.gnome.system.proxy.ftp" = "gds";
        "org.gnome.system.proxy.socks" = "gds";
      };
      inherit (finalAttrs) src;
    };

    updateScript =
      let
        updateSource = gitUpdater { };
        updatePatch = _experimental-update-script-combinators.copyAttrOutputToFile "libproxy.hardcodeGsettingsPatch" ./hardcode-gsettings.patch;
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updatePatch
      ];
  };

  meta = with lib; {
    description = "Library that provides automatic proxy configuration management";
    homepage = "https://libproxy.github.io/libproxy/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux ++ platforms.darwin;
    badPlatforms = [
      # Mandatory libpxbackend-1.0 shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
    mainProgram = "proxy";
  };
})
