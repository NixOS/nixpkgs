{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  coreutils,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  glib,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glib-testing";
  version = "0.2.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "installedTests"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "pwithnall";
    repo = "libglib-testing";
    rev = finalAttrs.version;
    hash = "sha256-OgKWC4plX4oiIakd/8bHtyiuZijV58URILXUHQqFMW8=";
  };

  patches = [
    # allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postPatch = ''
    # Note: Does not appear to be needed by anything.
    substituteInPlace libglib-testing/dbus-queue.c \
      --replace-fail 'Exec=/bin/true' 'Exec=${coreutils}/bin/true'
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.glib-testing;
    };
  };

  meta = {
    description = "Test library providing test harnesses and mock classes complementing the classes provided by GLib";
    homepage = "https://gitlab.gnome.org/pwithnall/libglib-testing";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
})
