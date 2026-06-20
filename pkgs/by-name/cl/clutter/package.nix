{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGLU,
  libGL,
  libx11,
  libxext,
  libxfixes,
  libxdamage,
  libxcomposite,
  libxi,
  libxcb,
  cogl,
  pango,
  atk,
  json-glib,
  gobject-introspection,
  gtk3,
  gnome,
  libinput,
  libgudev,
  libxkbcommon,
}:

let
  version = "1.26.4";
in
stdenv.mkDerivation {
  pname = "clutter";
  inherit version;

  src = fetchurl {
    url = "mirror://gnome/sources/clutter/${lib.versions.majorMinor version}/clutter-${version}.tar.xz";
    sha256 = "1rn4cd1an6a9dfda884aqpcwcgq8dgydpqvb19nmagw4b70zlj4b";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];
  propagatedBuildInputs = [
    cogl
    pango
    atk
    json-glib
    gobject-introspection
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libx11
    libGL
    libGLU
    libxext
    libxfixes
    libxdamage
    libxcomposite
    libxi
    libxcb
    libinput
    libgudev
    libxkbcommon
  ];

  configureFlags = [
    "--enable-introspection" # needed by muffin AFAIK
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--without-x"
    "--enable-x11-backend=no"
    "--enable-quartz-backend=yes"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  #doCheck = true; # no tests possible without a display

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "clutter";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Library for creating fast, dynamic graphical user interfaces";

    longDescription = ''
      Clutter is free software library for creating fast, compelling,
      portable, and dynamic graphical user interfaces.  It is a core part
      of MeeGo, and is supported by the open source community.  Its
      development is sponsored by Intel.

      Clutter uses OpenGL for rendering (and optionally OpenGL|ES for use
      on mobile and embedded platforms), but wraps an easy to use,
      efficient, flexible API around GL's complexity.

      Clutter enforces no particular user interface style, but provides a
      rich, generic foundation for higher-level toolkits tailored to
      specific needs.
    '';

    license = lib.licenses.lgpl2Plus;
    homepage = "http://www.clutter-project.org/";

    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
