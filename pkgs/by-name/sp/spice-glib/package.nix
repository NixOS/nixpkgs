{
  lib,
  stdenv,
  fetchFromGitLab,
  acl,
  buildPackages,
  cyrus_sasl,
  libepoxy,
  gettext,
  gi-docgen,
  gobject-introspection,
  gst_all_1,
  gtk3,
  hwdata,
  json-glib,
  libcacard,
  libcap_ng,
  libjpeg_turbo,
  libopus,
  libsoup_3,
  libusb1,
  lz4,
  meson,
  mesonEmulatorHook,
  ninja,
  openssl,
  perl,
  phodav,
  pixman,
  pkg-config,
  polkit,
  python3,
  spice-protocol,
  usbredir,
  vala,
  wayland-protocols,
  wayland-scanner,
  zlib,
  wrapGAppsHook3,
  wrapGAppsNoGuiHook,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withGtk ? false,
  withPolkit ? stdenv.hostPlatform.isLinux,
}:

# If this package is built with polkit support (withPolkit=true),
# usb redirection requires spice-client-glib-usb-acl-helper to run setuid root.
# The helper confirms via polkit that the user has an active session,
# then adds a device acl entry for that user.
# Example NixOS config to create a setuid wrapper for the helper:
# security.wrappers.spice-client-glib-usb-acl-helper.source =
#   "${pkgs.spice-glib}/bin/spice-client-glib-usb-acl-helper";
# On non-NixOS installations, make a setuid copy of the helper
# outside the store and adjust PATH to find the setuid version.

# If this package is built without polkit support (withPolkit=false),
# usb redirection requires read-write access to usb devices.
# This can be granted by adding users to a custom group like "usb"
# and using a udev rule to put all usb devices in that group.
# Example NixOS config:
#  users.groups.usb = {};
#  users.users.dummy.extraGroups = [ "usb" ];
#  services.udev.extraRules = ''
#    KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"
#  '';

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = if withGtk then "spice-gtk" else "spice-glib";
  version = "0.43";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "spice-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e0B3shnXDwKMPvy1nyz/iNPPRGJbnygh0bqIufq/93g=";
    fetchSubmodules = true;
  };
  # Required since we strip .git
  postUnpack = ''
    echo "${finalAttrs.version}" > source/.tarball-version
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    perl
    pkg-config
    python3
    python3.pkgs.pyparsing
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    mesonEmulatorHook
  ]
  ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
    vala
  ]
  ++ (
    if withGtk then
      [
        wrapGAppsHook3
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        wayland-scanner
      ]
    else
      [
        wrapGAppsNoGuiHook
      ]
  );

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    cyrus_sasl
    json-glib
    libcacard
    libjpeg_turbo
    libopus
    libsoup_3
    libusb1
    lz4
    openssl
    phodav
    pixman
    spice-protocol
    usbredir
    zlib
  ]
  ++ lib.optionals withPolkit [
    polkit
    acl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    libepoxy
  ]
  ++ lib.optionals withGtk [
    gtk3
  ]
  ++ lib.optionals (withGtk && stdenv.hostPlatform.isLinux) [
    wayland-protocols
  ];

  env.PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  mesonFlags = [
    "-Dusb-acl-helper-dir=${placeholder "out"}/bin"
    "-Dusb-ids-path=${hwdata}/share/hwdata/usb.ids"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "vapi" withIntrospection)
    (lib.mesonEnable "polkit" withPolkit)
    (lib.mesonEnable "libcap-ng" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "egl" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "gtk" withGtk)
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    "-Dcoroutine=gthread" # Fixes "Function missing:makecontext"
  ];

  postPatch = ''
    # get rid of absolute path to helper in store so we can use a setuid wrapper
    substituteInPlace src/usb-acl-helper.c \
      --replace-fail 'ACL_HELPER_PATH"/' '"'
    # don't try to setcap/suid in a nix builder
    substituteInPlace src/meson.build \
      --replace-fail "meson.add_install_script('../build-aux/setcap-or-suid'," \
      "# meson.add_install_script('../build-aux/setcap-or-suid',"

    patchShebangs subprojects/keycodemapdb/tools/keymap-gen
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # drm/drm_fourcc.h is a Linux kernel uAPI header; only one constant is used
    substituteInPlace src/channel-display.c --replace-fail \
      '#include <drm/drm_fourcc.h>' \
      '#define DRM_FORMAT_MOD_INVALID 0x00ffffffffffffffULL'
  '';

  meta = {
    description = "SPICE Glib client library" + lib.optionalString withGtk " with GTK+3 widget";
    longDescription =
      if withGtk then
        ''
          spice-glib provides support for Glib apps to interact with the SPICE
          protocol and spice-gtk itself provides a GTK 3 SPICE widget.
          The package features glib-based objects for SPICE protocol parsing and a GTK widget
          for embedding the SPICE display into other applications such as virt-manager.
          Python bindings are available too.
          This package is also available without the GTK+3 widget, use 'spice-glib' for this.
        ''
      else
        ''
          spice-glib provides support for Glib apps to interact with the SPICE
          protocol. It features glib-based objects for SPICE protocol parsing.
          Python bindings are available too.
          This package is also available with a GTK+3 widget, use 'spice-gtk' for this.
        '';
    homepage = "https://www.spice-space.org/";
    license = lib.licenses.lgpl21;
    maintainers = [
      lib.maintainers.xeji
      lib.maintainers.theCapypara
    ];
    platforms = lib.platforms.unix;
  };
})
