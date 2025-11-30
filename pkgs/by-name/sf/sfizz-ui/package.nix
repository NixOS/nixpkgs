{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libsndfile,
  xorg,
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
  # Actually 1.2.3 plus a few commits:
  version = "1.2.3a";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = "sfizz-ui";
    # we need to include https://github.com/sfztools/sfizz-ui/commit/9ce7fac3544406dfc3de66d4848bab2c72ec97af
    # otherwise it doesn't compile:
    rev = "93da042624117da7c722a237d540a058cb629df0";
    hash = "sha256-LuxgMP97+VcYaWNF1315wot099+khShgqjOTQG3WyjU=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libjack2
    libsndfile
    flac
    libogg
    libvorbis
    libopus
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    libxkbcommon
    cairo
    glib
    freetype
    pango
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
    substituteInPlace plugins/editor/src/editor/NativeHelpers.cpp \
      --replace-fail 'auto glibPath = g_find_program_in_path("zenity");' \
      'auto glibPath = g_strdup("${zenity}/bin/zenity");'

    substituteInPlace plugins/editor/external/vstgui4/vstgui/lib/platform/linux/x11fileselector.cpp \
      --replace-fail 'zenitypath = "zenity"' \
      'zenitypath = "${zenity}/bin/zenity"'
  '';

  meta = {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      joostn
      magnetophon
    ];
    platforms = lib.platforms.linux;
  };
})
