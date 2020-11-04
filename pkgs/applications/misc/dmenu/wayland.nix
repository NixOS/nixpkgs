{ stdenv, fetchFromGitHub, meson, ninja, cairo, pango, pkg-config, wayland-protocols
, glib, wayland, libxkbcommon, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "dmenu-wayland-unstable";
  version = "2020-07-06";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = "dmenu-wayland";
    rev = "304c8e917651ee02b16ebf0b7097a5c53fa2236b";
    sha256 = "0rkpmpk7xkcfbnv9vpg8n65423z5xpgp0hm2vg0rxf9354bjin7k";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ meson ninja pkg-config makeWrapper ];
  buildInputs = [ cairo pango wayland-protocols glib wayland libxkbcommon ];

  postInstall = ''
    wrapProgram $out/bin/dmenu-wl_run \
      --prefix PATH : $out/bin
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    platforms = platforms.linux;
    description = "dmenu for wayland-compositors";
    homepage = "https://github.com/nyyManni/dmenu-wayland";
    maintainers = with maintainers; [ ma27 ];
  };
}
