{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libsndfile,
  libxcb-util,
  libxcb-render-util,
  libxcb-keysyms,
  libxcb-image,
  libxcb-cursor,
  libxdmcp,
  libxau,
  libx11,
  libxcb,
  freetype,
  libxkbcommon,
  cairo,
  glib,
  zenity,
  flac,
  libogg,
  libvorbis,
  libopus,
  cmake,
  pango,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfizz-ui";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = "sfizz-ui";
    rev = finalAttrs.version;
    # Upstream requires submodules:
    # VST3_SDK, vstgui4, sfzt_auwrapper and sfizz
    fetchSubmodules = true;
    hash = "sha256-Rf1i+tu91bqzO1wWJi7mw2BvbX9K0mDNPqsTUoqPd4U=";
  };

  buildInputs = [
    cairo
    flac
    freetype
    glib
    libjack2
    libogg
    libopus
    libsndfile
    libvorbis
    libxkbcommon
    pango
    libx11
    libxau
    libxcb
    libxdmcp
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    zenity
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "SFIZZ_TESTS" true)
  ];

  doCheck = true;

  postPatch = ''
    # Hard code zenity path (1/2):
    substituteInPlace plugins/editor/src/editor/NativeHelpers.cpp \
      --replace-fail \
        'auto glibPath = g_find_program_in_path("zenity");' \
        'auto glibPath = g_strdup("${lib.getExe zenity}");'

    # Hard code zenity path (2/2):
    substituteInPlace plugins/editor/external/vstgui4/vstgui/lib/platform/linux/x11fileselector.cpp \
      --replace-fail \
        'zenitypath = "zenity"' \
        'zenitypath = "${lib.getExe zenity}"'

    # Fix compilation error in GCC 14:
    # https://github.com/sfztools/vstgui/pull/5
    # https://github.com/steinbergmedia/vstgui/issues/324
    # This has been upstreamed into master, remove when we switch to a newer upstream version.
    substituteInPlace plugins/editor/external/vstgui4/vstgui/lib/finally.h \
      --replace-fail \
        "other.invoke (false);" \
        "other.invoke = false;"
  '';

  meta = {
    description = "SFZ based sampler, providing AU / LV2 / PD / VST3 plugins using the sfizz library";
    homepage = "https://github.com/sfztools/sfizz-ui/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      joostn
      magnetophon
    ];
    platforms = lib.platforms.linux;
  };
})
