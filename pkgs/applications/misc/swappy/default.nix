{ lib, stdenv, fetchFromGitHub
, meson
, ninja
, wayland
, cairo
, pango
, gtk
, pkg-config
, scdoc
, libnotify
, glib
}:

stdenv.mkDerivation rec {
  pname = "swappy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bm184fbzylymh4kr7n8gy9plsdxif8xahc1zmkgdg1a0kwgws2x";
  };

  nativeBuildInputs = [ glib meson ninja pkg-config scdoc ];

  buildInputs = [ cairo pango gtk libnotify wayland glib ];

  strictDeps = true;

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with lib; {
    homepage = "https://github.com/jtheoof/swappy";
    description = "A Wayland native snapshot editing tool, inspired by Snappy on macOS";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
