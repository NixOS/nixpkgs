{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  gettext,
  vala,
  libcap_ng,
  libvirt,
  libxml2,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gobject-introspection,
  withDocs ? stdenv.hostPlatform == stdenv.buildPlatform,
  gtk-doc,
  docbook-xsl-nons,
}:

stdenv.mkDerivation rec {
  pname = "libvirt-glib";
  version = "5.0.0";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional withDocs "devdoc";

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/${pname}-${version}.tar.xz";
    sha256 = "m/7DRjgkFqNXXYcpm8ZBsqRkqlGf2bEofjGKpDovO4s=";
  };

  patches = [
    (fetchpatch {
      name = "relax-max-stack-size-limit.patch";
      url = "https://gitlab.com/libvirt/libvirt-glib/-/commit/062f21ccaa810087637ae24e0eb69f1a0f0a45f5.patch";
      hash = "sha256-6mvINDd1HYS7oZsyNiyEwdNJfK5I5nPx86TRMq2RevA=";
    })
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      gettext
      vala
      gobject-introspection
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
    ]
    ++ lib.optionals withDocs [
      gtk-doc
      docbook-xsl-nons
    ];

  buildInputs =
    [
      libvirt
      libxml2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap_ng
    ];

  strictDeps = true;

  # The build system won't let us build with docs or introspection
  # unless we're building natively, but will still do a mandatory
  # check for the dependencies for those things unless we explicitly
  # disable the options.
  mesonFlags = [
    (lib.mesonEnable "docs" withDocs)
    (lib.mesonEnable "introspection" withIntrospection)
  ];

  meta = with lib; {
    description = "Library for working with virtual machines";
    longDescription = ''
      libvirt-glib wraps libvirt to provide a high-level object-oriented API better
      suited for glib-based applications, via three libraries:

      - libvirt-glib    - GLib main loop integration & misc helper APIs
      - libvirt-gconfig - GObjects for manipulating libvirt XML documents
      - libvirt-gobject - GObjects for managing libvirt objects
    '';
    homepage = "https://libvirt.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
