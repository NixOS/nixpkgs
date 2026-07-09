{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  meson,
  python3,
  ninja,
  gusb,
  pixman,
  glib,
  gobject-introspection,
  cairo,
  libgudev,
  udevCheckHook,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfprint";
  version = "1.94.10";
  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = "libfprint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aNBUIKY3PP5A07UNg3N0qq+2cwb6Fk67oKQcXgr2G/4=";
  };

  patches = [
    # New hardware support since 1.94.10, just new USB Product IDs
    (fetchpatch {
      name = "realtek-3274-9003.patch";
      url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/a25f71cf97820c51edc4c32f84686fcdc608d9d1.patch";
      sha256 = "sha256-T9rvT53Ij+5gtiVOp+xfzQwiVkyF0m6lZAUCXWmaugg=";
    })
    (fetchpatch {
      name = "elan-0c58.patch";
      url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/4610f2285e6373c2fe4ead0dff4ebf8dabe4e532.patch";
      sha256 = "sha256-VR96V+7FvSa8sE6JpcCx/slZ0MaK9HLuNuAay2P9C6M=";
    })
    (fetchpatch {
      name = "elan-04F3-0C9C.patch";
      url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/2bdc2b7ca6d8bedc675054934fbc8f8b6a21deac.patch";
      sha256 = "sha256-LFMip9Mq55uDRgHkW+XeI+j0mILOb7DIHscHjyKe4yE=";
    })
    (fetchpatch {
      name = "focal-077a-079a.patch";
      url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/2c7842c905147a2d127c1b168b2e9d432b8c91a4.patch";
      sha256 = "sha256-PuISGITn0/6AWY0WVUfViZtdcQFh+0s+4OLIszqdLUs=";
    })
    (fetchpatch {
      name = "focal-a97a.patch";
      url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/0dc384b90ed8cd78b3e8d7c0d30a953bd088b98c.patch";
      sha256 = "sha256-X/wl4MpxfQ7sLlFTkkiDQGyRFQ6lC9pdcy3XPrSeOZw=";
    })
  ];

  postPatch = ''
    patchShebangs \
      tests/test-runner.sh \
      tests/unittest_inspector.py \
      tests/virtual-image.py \
      tests/umockdev-test.py \
      tests/test-generated-hwdb.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
    udevCheckHook
  ];

  buildInputs = [
    gusb
    pixman
    glib
    cairo
    libgudev
    openssl
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    "-Ddrivers=all"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
  ];

  nativeInstallCheckInputs = [
    (python3.withPackages (p: with p; [ pygobject3 ]))
  ];

  # We need to run tests _after_ install so all the paths that get loaded are in
  # the right place.
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ninjaCheckPhase

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://fprint.freedesktop.org/";
    description = "Library designed to make it easy to add support for consumer fingerprint readers";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
