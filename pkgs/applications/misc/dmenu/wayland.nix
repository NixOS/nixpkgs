{ stdenv, fetchFromGitHub, meson, ninja, cairo, pango, pkg-config, wayland-protocols
, glib, wayland, libxkbcommon, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "dmenu-wayland-unstable";
  version = "2020-04-03";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = "dmenu-wayland";
    rev = "550a7c39f3f925b803d51c616609c8cb6c0ea543";
    sha256 = "0az3w1csn4x6mjyacg6lf70kykdfqamic3hbr57mj83i5jjv0jlv";
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
