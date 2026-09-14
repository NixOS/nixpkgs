{
  lib,
  stdenv,
  testers,
  fetchFromGitLab,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  glib,
  gupnp-igd,
  gst_all_1,
  gnutls,
  enableDocumentation ? stdenv.buildPlatform == stdenv.hostPlatform,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  graphviz,
  python3,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnice";
  version = "0.1.24";

  outputs = [
    "bin"
    "out"
    "dev"
  ]
  ++ lib.optionals enableDocumentation [ "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libnice";
    repo = "libnice";
    tag = finalAttrs.version;
    hash = "sha256-7y+yTf/kp4uy9LZCbcMisA1892csBjdXQU5mOVnrxRY=";
  };

  patches = [
    # Bumps the gupnp_igd_dep version requested to 1.6
    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/255
    ./gupnp-igd-bump.patch
  ]
  # TODO: investigate what's wrong
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/353
    ./musl.patch
  ];

  # specifies <1.30, but also works with later versions
  postPatch = ''
    substituteInPlace docs/reference/libnice/meson.build \
      --replace-fail "version: '<1.30', " ""
  ''
  # Manually remove failing tests until we have disabledTests for meson
  # The failures are due to the sandbox restricting network sockets
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace tests/meson.build \
      --replace-fail "'test-slow-resolving'," "" \
      --replace-fail "'test-set-port-range'," ""
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ]
  ++ lib.optionals enableDocumentation [
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    graphviz
    python3
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gnutls
    gupnp-igd
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = lib.mapAttrsToList lib.mesonEnable {
    gtk_doc = enableDocumentation;
    introspection = withIntrospection;

    # requires many dependencies and probably not useful for our users
    examples = false;
    tests = finalAttrs.finalPackage.doCheck;

    gstreamer = true;

    glib_debug = false;
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://gitlab.freedesktop.org/libnice/libnice/-/blob/${finalAttrs.version}/NEWS";
    description = "GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactive Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
    homepage = "https://libnice.freedesktop.org/";
    pkgConfigModules = [ "nice" ];
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl21
      mpl11
    ];
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
