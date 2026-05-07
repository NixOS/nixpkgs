{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  glib,
  json-glib,
  gnutls,
  gpgme,
  gobject-introspection,
  vala,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  python3,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjcat";
  version = "0.2.3";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libjcat";
    rev = finalAttrs.version;
    sha256 = "sha256-3Ttk5nwVLB/Ll4Xz25JODOKHsGrOxKeSF2f+6QhDI2Q=";
  };

  patches = [
    # Installed tests are installed to different output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    vala
    gnutls
    gtk-doc
    python3
  ];

  buildInputs = [
    glib
    json-glib
    gnutls
    gpgme
  ];

  mesonFlags = [
    "-Dgtkdoc=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.libjcat;
    };
  };

  meta = {
    description = "Library for reading and writing Jcat files";
    mainProgram = "jcat-tool";
    homepage = "https://github.com/hughsie/libjcat";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
