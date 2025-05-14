{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  nixosTests,
  pkg-config,
  glib,
  gettext,
  makeWrapper,
  gnutls,
  libproxy,
  gnome,
  gsettings-desktop-schemas,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "glib-networking";
  version = "2.80.1";

  outputs = [
    "out"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glib-networking/${lib.versions.majorMinor version}/glib-networking-${version}.tar.xz";
    hash = "sha256-uA4odBV81VBx8bZxD6C5EdWsXeEGqe4qTJx77mF4L44=";
  };

  patches = [
    (replaceVars ./hardcode-gsettings.patch {
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })

    ./installed-tests-path.patch

    # pkcs11 tests provide a relative path that gnutls of course isn't able to
    # load, resulting in test failures
    # https://gitlab.gnome.org/GNOME/glib-networking/-/blob/2.78.1/tls/tests/certificate.c#L926
    # https://gitlab.gnome.org/GNOME/glib-networking/-/blob/2.78.1/tls/tests/connection.c#L3380
    ./disable-pkcs11-tests.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    makeWrapper
    glib # for gio-querymodules
  ];

  buildInputs = [
    glib
    gnutls
    libproxy
    gsettings-desktop-schemas
    bash # installed-tests shebangs
  ];

  doCheck = false; # tests need to access the certificates (among other things)

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postFixup = ''
    find "$installedTests/libexec" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d "" file; do
      echo "Wrapping program '$file'"
      wrapProgram "$file" --prefix GIO_EXTRA_MODULES : "$out/lib/gio/modules"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glib-networking";
      versionPolicy = "odd-unstable";
    };

    tests = {
      installedTests = nixosTests.installed-tests.glib-networking;
    };
  };

  meta = with lib; {
    description = "Network-related giomodules for glib";
    homepage = "https://gitlab.gnome.org/GNOME/glib-networking";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
    badPlatforms = [
      # GIO shared modules are mandatory.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
}
