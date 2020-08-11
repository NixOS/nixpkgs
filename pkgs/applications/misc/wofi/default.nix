{ stdenv, lib, fetchhg, fetchpatch, pkg-config, meson, ninja, wayland, gtk3, wrapGAppsHook, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.2.1";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "v${version}";
    sha256 = "0hx61br19dlmc3lay23ww3n9ry06m7b6xrkjx7sk4vrg1422iq99";
  };

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook installShellFiles ];
  buildInputs = [ wayland gtk3 ];

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
