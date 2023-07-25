{ lib, stdenv, fetchFromGitHub, meson, ninja, cairo, pango, pkg-config, wayland-protocols
, glib, wayland, libxkbcommon, makeWrapper, wayland-scanner
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "dmenu-wayland-unstable";
  version = "2022-11-04";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = "dmenu-wayland";
    rev = "b60047236ef7a4e5dcde6c4ac0dcfaa070d90041";
    sha256 = "sha256-CeJWLBPAzE3JITVuS6f4CQxLz9v09WvfG3O0wErJJS4=";
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
