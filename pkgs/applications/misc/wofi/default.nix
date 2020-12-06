{ stdenv, lib, fetchhg, fetchpatch, pkg-config, meson, ninja, wayland, gtk3, wrapGAppsHook, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.2.3";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "v${version}";
    sha256 = "0glpb2gf5n78s01z3rn614ak8ibxhfr824gy6xlljbxclgds264i";
  };

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook installShellFiles ];
  buildInputs = [ wayland gtk3 ];

  patches = [
    # https://todo.sr.ht/~scoopta/wofi/121
    ./do_not_follow_symlinks.patch
  ];

  postInstall = ''
    installManPage man/wofi*
  '';

  meta = with lib; {
    description = "A launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ elyhaka ];
    platforms = with platforms; linux;
  };
}
