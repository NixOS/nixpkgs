{ stdenv, lib, fetchhg, fetchpatch, pkg-config, meson, ninja, wayland, gtk3, wrapGAppsHook, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.2.4";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "v${version}";
    sha256 = "1bnf078fg1kwslzwm1mjxwcqqq3bhk1dzymwfw9gk3brqbxrl75c";
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
