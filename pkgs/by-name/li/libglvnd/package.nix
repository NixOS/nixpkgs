{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  python3,
  addDriverRunpath,
  libX11,
  libXext,
  xorgproto,
}:

stdenv.mkDerivation rec {
  pname = "libglvnd";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "glvnd";
    repo = "libglvnd";
    rev = "v${version}";
    sha256 = "sha256-2U9JtpGyP4lbxtVJeP5GUgh5XthloPvFIw28+nldYx8=";
  };

  patches = [
    # Enable 64-bit file APIs on 32-bit systems:
    #   https://gitlab.freedesktop.org/glvnd/libglvnd/-/merge_requests/288
    (fetchpatch {
      name = "large-file.patch";
      url = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/commit/956d2d3f531841cabfeddd940be4c48b00c226b4.patch";
      hash = "sha256-Y6YCzd/jZ1VZP9bFlHkHjzSwShXeA7iJWdyfxpgT2l0=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    addDriverRunpath
  ];
  buildInputs = [
    libX11
    libXext
    xorgproto
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/GLdispatch/Makefile.am \
      --replace "-Xlinker --version-script=$(VERSION_SCRIPT)" "-Xlinker"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
      # FHS paths are added so that non-NixOS applications can find vendor files.
      "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${addDriverRunpath.driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""

      "-Wno-error=array-bounds"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error"
      "-Wno-int-conversion"
    ]
  );

  configureFlags =
    [ ]
    # Indirectly: https://bugs.freedesktop.org/show_bug.cgi?id=35268
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-tls"
    # Remove when aarch64-darwin asm support is upstream: https://gitlab.freedesktop.org/glvnd/libglvnd/-/issues/216
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) "--disable-asm";

  outputs = [
    "out"
    "dev"
  ];

  # Set RUNPATH so that libGLX can find driver libraries in /run/opengl-driver(-32)/lib.
  # Note that libEGL does not need it because it uses driver config files which should
  # contain absolute paths to libraries.
  postFixup = ''
    addDriverRunpath $out/lib/libGLX.so
  '';

  passthru = { inherit (addDriverRunpath) driverLink; };

  meta = {
    description = "GL Vendor-Neutral Dispatch library";
    longDescription = ''
      libglvnd is a vendor-neutral dispatch layer for arbitrating OpenGL API
      calls between multiple vendors. It allows multiple drivers from different
      vendors to coexist on the same filesystem, and determines which vendor to
      dispatch each API call to at runtime.
      Both GLX and EGL are supported, in any combination with OpenGL and OpenGL ES.
    '';
    inherit (src.meta) homepage;
    # https://gitlab.freedesktop.org/glvnd/libglvnd#libglvnd:
    changelog = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/tags/v${version}";
    license = with lib.licenses; [
      mit
      bsd1
      bsd3
      gpl3Only
      asl20
    ];
    platforms = lib.platforms.unix;
    # https://gitlab.freedesktop.org/glvnd/libglvnd/-/issues/212
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    maintainers = [ ];
  };
}
