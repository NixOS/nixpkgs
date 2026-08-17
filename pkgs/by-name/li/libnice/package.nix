{
  lib,
  stdenv,
  testers,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.1.23";

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
    hash = "sha256-UPppE5kBois0jJwsHKefBC8iTfSIkPZXV6XnUBnEFn8=";
  };

  patches = [
    # Bumps the gupnp_igd_dep version requested to 1.6
    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/255
    ./gupnp-igd-bump.patch
  ]
  # TODO: investigate what's wrong
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (fetchpatch {
      name = "freebsd.patch";
      url = "https://gitlab.freedesktop.org/libnice/libnice/-/commit/479f0813a571ff035bf00de679db452a0441125b.patch";
      hash = "sha256-rr8pAb8TjU85jYWUjsMMKkLxxXVE3B+IjfAyOw9suo0=";
    })

    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/353
    ./musl.patch
  ];

  # specifies <1.30, but also works with later versions
  postPatch = ''
    substituteInPlace docs/reference/libnice/meson.build \
      --replace-fail "version: '<1.30', " ""
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

  # Tests are flaky
  # see https://github.com/NixOS/nixpkgs/pull/53293#issuecomment-453739295
  doCheck = false;

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
