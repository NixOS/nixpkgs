{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gdk-pixbuf,
  gd,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "libsixel";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "libsixel";
    repo = "libsixel";
    rev = "v${version}";
    hash = "sha256-obzBZAknN3N7+Bvtd0+JHuXcemVb7wRv+Pt4VjS6Bck=";
  };

  buildInputs = [
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
    # build system seems to be broken here, it still seems to handle jpeg
    # through some other ways.
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
}
