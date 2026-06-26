{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  python3,
  gobject-introspection,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  glib,
  gupnp-igd,
  gst_all_1,
  gnutls,
  graphviz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnice";
  version = "0.1.23";

  outputs = [
    "bin"
    "out"
    "dev"
  ]
  ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "https://libnice.freedesktop.org/releases/libnice-${finalAttrs.version}.tar.gz";
    hash = "sha256-YY/E6N45O3GbFkHB2O7AGCbU050VrekmedIhx/Xk5w0=";
  };

  patches = [
    # Bumps the gupnp_igd_dep version requested to 1.6
    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/255
    ./gupnp-igd-bump.patch

    (fetchpatch {
      name = "freebsd.patch";
      url = "https://gitlab.freedesktop.org/libnice/libnice/-/commit/479f0813a571ff035bf00de679db452a0441125b.patch";
      hash = "sha256-rr8pAb8TjU85jYWUjsMMKkLxxXVE3B+IjfAyOw9suo0=";
    })

    # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/353
    ./musl.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gobject-introspection

    # documentation
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    graphviz
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

  mesonFlags = [
    "-Dgtk_doc=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  # Tests are flaky
  # see https://github.com/NixOS/nixpkgs/pull/53293#issuecomment-453739295
  doCheck = false;

  meta = {
    changelog = "https://gitlab.freedesktop.org/libnice/libnice/-/blob/${finalAttrs.version}/NEWS";
    description = "GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactice Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
    homepage = "https://libnice.freedesktop.org/";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl21
      mpl11
    ];
  };
})
