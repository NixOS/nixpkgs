{ stdenv, fetchFromGitHub
, meson
, ninja
, wayland
, cairo
, pango
, gtk
, pkgconfig
, cmake
, scdoc
, libnotify
, gio-sharp
, glib
}:

stdenv.mkDerivation rec {
  name = "swappy-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = "swappy";
    rev = "v${version}";
    sha256 = "14ac2jmnak7avcz0jhqjm30vk7pv3gq5aq5rdyh84k8c613kkicf";
  };

  nativeBuildInputs = [ glib meson ninja pkgconfig cmake scdoc ];

  buildInputs = [ cairo pango gtk libnotify wayland glib ];

  strictDeps = true;

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jtheoof/swappy";
    description = "A Wayland native snapshot editing tool, inspired by Snappy on macOS ";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
