{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
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
  zstd,
  libnghttp2,
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "3.7.2";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-A7cIXfhWRSKMZJC2u/2ows5TlNDNcYQAX1UKgSJaxKo=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-15711.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/60aa1ce2bdc7bb5da33be9062f50bcec7db67fca.patch";
      hash = "sha256-13fU7zuzkb7wIH3BxylBaVyw6s/X6f4/ji9yYqYIcVg=";
    })
    (fetchpatch {
      name = "CVE-2026-12549.patch"; # Also: CVE-2026-77014, CVE-2026-77680
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/merge_requests/550.patch";
      hash = "sha256-Dpd1qyJlIqNp6MzqyCKQ6anQr887e4J3CAGXEyzQOYU=";
    })
    (fetchpatch {
      name = "CVE-2026-15713.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/24fb645fa949ece7d7e10363b77cf2d5fa2c2469.patch";
      hash = "sha256-TdWCOo2QnCnTbV0dPk4iGnNuwZO+LKSH1YFp2XAenwY=";
    })
    (fetchpatch {
      name = "CVE-2026-15712.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/3a6fb56a0cba42d11f5fd1db6dedcc7c2e92757b.patch";
      hash = "sha256-IPYr77720+LOi3fp+x2M4MTKOm62As0dh8lZ5hKsuTU=";
    })
    (fetchpatch {
      name = "CVE-2026-15714.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/79a52cadc490360e249cc2b23038d532b44dbf23.patch";
      hash = "sha256-p5J1QlfU+/be5YVahVTKt2QsxlRttrf62AYOa1QrwEo=";
    })
    (fetchpatch {
      name = "CVE-2026-85534.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/5f656cd97b8a6f4a5b8b7a30efb7c2cc8ef498fb.patch";
      hash = "sha256-DD5HO+ZCn9Q/lVWWG9WnTBSeOe37Y3GD4dvsP4YuCLI=";
    })
  ];

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
    zstd
    libnghttp2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
  ];

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

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libsoup";
    license = lib.licenses.lgpl2Plus;
    changelog = "https://gitlab.gnome.org/GNOME/libsoup/-/blob/${version}/NEWS";
    inherit (glib.meta) maintainers platforms teams;
  };
}
