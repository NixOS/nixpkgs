{ lib, stdenv, fetchFromGitHub, meson, ninja, cairo, pango, pkg-config, wayland-protocols
, glib, wayland, libxkbcommon, makeWrapper, wayland-scanner
, fetchpatch
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

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config makeWrapper wayland-scanner ];
  buildInputs = [ cairo pango wayland-protocols glib wayland libxkbcommon ];

  # Patch to support cross-compilation, see https://github.com/nyyManni/dmenu-wayland/pull/23/
  patches = [
    # can be removed when https://github.com/nyyManni/dmenu-wayland/pull/23 is included
    (fetchpatch {
      url = "https://github.com/nyyManni/dmenu-wayland/commit/3434410de5dcb007539495395f7dc5421923dd3a.patch";
      sha256 = "sha256-im16kU8RWrCY0btYOYjDp8XtfGEivemIPlhwPX0C77o=";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/dmenu-wl_run \
      --prefix PATH : $out/bin
  '';

  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.linux;
    description = "dmenu for wayland-compositors";
    homepage = "https://github.com/nyyManni/dmenu-wayland";
    maintainers = with maintainers; [ ];
  };
}
