{ stdenv, lib, fetchhg, pkg-config, meson, ninja, wayland, gtk3 }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.1.2";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "v${version}";
    sha256 = "086j5wshawjbwdmmmldivfagc2rr7g5a2gk11l0snqqslm294xsn";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ wayland gtk3 ];

  meta = with lib; {
    description = "A launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ erictapen ];
    platforms = with platforms; linux;
  };
}
