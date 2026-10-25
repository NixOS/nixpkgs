{
  stdenv,
  lib,
  fetchurl,
  glib,
  meson,
  ninja,
  pkg-config,
  gnome,
  libsysprof-capture,
  sqlite,
  buildPackages,
  gobject-introspection,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  vala,
  libpsl,
  python3,
  gi-docgen,
  brotli,
  libnghttp2,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsoup";
  version = "3.8.0";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${lib.versions.majorMinor finalAttrs.version}/libsoup-${finalAttrs.version}.tar.xz";
    hash = "sha256-u/CPo+A6iMMaPSeg2Hy0IulJDy0I4UkhEQPfbWOKIjg=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    python3
  ]
  ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    sqlite
    libpsl
    glib.out
    brotli
    libnghttp2
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dntlm=disabled"
    # Requires wstest from autobahn-testsuite.
    "-Dautobahn=disabled"
    # Requires gnutls, not added for closure size.
    "-Dpkcs11_tests=disabled"

    (lib.mesonEnable "docs" withIntrospection)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "sysprof" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "vapi" withIntrospection)
  ];

  # TODO: For some reason the pkg-config setup hook does not pick this up.
  env.PKG_CONFIG_PATH = "${libnghttp2.dev}/lib/pkgconfig";

  # HSTS tests fail.
  doCheck = false;
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs libsoup/
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libsoup_3";
      packageName = "libsoup";
      versionPolicy = "odd-unstable";
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libsoup";
    license = lib.licenses.lgpl2Plus;
    changelog = "https://gitlab.gnome.org/GNOME/libsoup/-/blob/${finalAttrs.version}/NEWS";
    inherit (glib.meta) maintainers platforms teams;
  };
})
