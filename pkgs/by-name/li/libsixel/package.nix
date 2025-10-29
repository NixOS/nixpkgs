{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gdk-pixbuf,
  gd,
  pkg-config,

  # Enable linking against image loading libraries as part of the
  # implementation of the sixel_helper_{load,write}_image_file() functions.
  # These helper functions are not needed for the main functionality of the
  # library to encode image buffers to sixels.
  #
  # libsixel already uses vendored stb image loading to provide basic
  # implementations, but also allows for the "gd" library to be linked for
  # a wider set of image formats.
  # This pulls in a large amount of deps bloating the resulting library.
  #
  # Default off, but configurable in case you really need it.
  withGd ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsixel";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "libsixel";
    repo = "libsixel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-obzBZAknN3N7+Bvtd0+JHuXcemVb7wRv+Pt4VjS6Bck=";
  };

  buildInputs = lib.optionals withGd [
    gdk-pixbuf
    gd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  doCheck = true;

  mesonFlags = [
    "-Dtests=enabled"
    "-Dimg2sixel=enabled"
    "-Dsixel2png=enabled"

    (lib.mesonEnable "gd" withGd)

    # build system seems to be broken here; error message indicates pkconfig
    # issue.
    # Not to worry: jpeg and png are handled by the built-in stb and/or gd lib.
    "-Djpeg=disabled"
    "-Dpng=disabled"
  ];

  meta = with lib; {
    description = "SIXEL library for console graphics, and converter programs";
    homepage = "https://github.com/libsixel/libsixel";
    maintainers = with lib.maintainers; [ hzeller ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
})
