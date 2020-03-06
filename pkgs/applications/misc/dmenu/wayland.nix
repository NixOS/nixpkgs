{ stdenv, fetchFromGitHub, meson, ninja, cairo, pango, pkg-config, wayland-protocols
, glib, wayland, libxkbcommon, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "dmenu-wayland-unstable";
  version = "2020-02-28";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = "dmenu-wayland";
    rev = "68e08e8bcde10a10ac3290431f173c6c7fce4238";
    sha256 = "10b1v2brgpgb6wkzn62haj56zmkf3aq6fs3p9rp6bxiw8bs2nvlm";
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
