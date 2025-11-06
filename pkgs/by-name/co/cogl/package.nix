{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGL,
  glib,
  gdk-pixbuf,
  xorg,
  libintl,
  pangoSupport ? true,
  pango,
  cairo,
  gobject-introspection,
  wayland,
  gnome,
  libgbm,
  mesa-gl-headers,
  automake,
  autoconf,
  gstreamerSupport ? false,
  gst_all_1,
  harfbuzz,
}:

stdenv.mkDerivation rec {
  pname = "cogl";
  version = "1.22.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/cogl-${version}.tar.xz";
    sha256 = "0nfph4ai60ncdx7hy6hl1i1cmp761jgnyjfhagzi0iqq36qb41d8";
  };

  patches = [
    # Some deepin packages need the following patches. They have been
    # submitted by Fedora on the GNOME Bugzilla
    # (https://bugzilla.gnome.org/787443). Upstream thinks the patch
    # could be merged, but dev can not make a new release.
    ./patches/gnome_bugzilla_787443_359589_deepin.patch
    ./patches/gnome_bugzilla_787443_361056_deepin.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    libintl
    automake
    autoconf
    gobject-introspection
  ];

  configureFlags = [
    "--enable-introspection"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-wayland-egl-server"
    "--enable-gles1"
    "--enable-gles2"
    # Force linking against libGL.
    # Otherwise, it tries to load it from the runtime library path.
    "LIBS=-lGL"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-glx"
    "--without-x"
  ]
  ++ lib.optionals gstreamerSupport [
    "--enable-cogl-gst"
  ];

  # TODO: this shouldn't propagate so many things
  # especially not gobject-introspection
  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    gobject-introspection
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libgbm
    mesa-gl-headers
    libGL
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
  ]
  ++ lib.optionals gstreamerSupport [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  buildInputs = lib.optionals pangoSupport [
    pango
    cairo
    harfbuzz
  ];

  env = {
    COGL_PANGO_DEP_CFLAGS = toString (
      lib.optionals (stdenv.hostPlatform.isDarwin && pangoSupport) [
        "-I${pango.dev}/include/pango-1.0"
        "-I${cairo.dev}/include/cairo"
        "-I${harfbuzz.dev}/include/harfbuzz"
      ]
    );
  }
  // lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  #doCheck = true; # all tests fail (no idea why)

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Small open source library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Cogl is a small open source library for using 3D graphics hardware for
      rendering. The API departs from the flat state machine style of OpenGL
      and is designed to make it easy to write orthogonal components that can
      render without stepping on each other's toes.
    '';

    platforms = platforms.unix;
    license = with licenses; [
      mit
      bsd3
      publicDomain
      sgi-b-20
    ];
  };
}
