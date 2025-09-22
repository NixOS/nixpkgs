{
  stdenv,
  fetchgit,
  lib,
  pkg-config,
  autoreconfHook,
  glib,
  dbus-glib,
  gtkVersion ? "3",
  gtk2,
  libindicator-gtk2,
  libdbusmenu-gtk2,
  gtk3,
  libindicator-gtk3,
  libdbusmenu-gtk3,
  gtk-doc,
  vala,
  gobject-introspection,
  monoSupport ? false,
  mono,
  gtk-sharp-2_0,
  gtk-sharp-3_0,
  testers,
}:

let
  throwBadGtkVersion = throw "unknown GTK version ${gtkVersion}";
in

stdenv.mkDerivation (finalAttrs: {
  pname =
    let
      postfix = if monoSupport then "sharp" else "gtk${gtkVersion}";
    in
    "libappindicator-${postfix}";
  version = "12.10.1+20.10.20200706.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libappindicator";
    rev = "fe25e53bc7e39cd59ad6b3270cd7a6a9c78c4f44";
    sha256 = "0xjvbl4gn7ra2fs6gn2g9s787kzb5cg9hv79iqsz949rxh4iw32d";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    vala
    gobject-introspection
    gtk-doc
  ];

  propagatedBuildInputs =
    {
      "2" = [
        gtk2
        libdbusmenu-gtk2
      ];
      "3" = [
        gtk3
        libdbusmenu-gtk3
      ];
    }
    .${gtkVersion} or throwBadGtkVersion;

  buildInputs = [
    glib
    dbus-glib
    {
      "2" = libindicator-gtk2;
      "3" = libindicator-gtk3;
    }
    .${gtkVersion} or throwBadGtkVersion
  ]
  ++ lib.optionals monoSupport [
    mono
    {
      "2" = gtk-sharp-2_0;
      "3" = gtk-sharp-3_0;
    }
    .${gtkVersion} or throwBadGtkVersion
  ];

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=${gtkVersion}"
  ];

  doCheck = false; # generates shebangs in check phase, too lazy to fix

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Library to allow applications to export a menu into the Unity Menu bar";
    homepage = "https://launchpad.net/libappindicator";
    license = with licenses; [
      lgpl21
      lgpl3
    ];
    pkgConfigModules =
      {
        "2" = [ "appindicator-0.1" ];
        "3" = [ "appindicator3-0.1" ];
      }
      .${gtkVersion} or throwBadGtkVersion;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
    # TODO: Resolve the issues with the Mono bindings.
    broken = monoSupport;
  };
})
