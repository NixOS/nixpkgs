{ stdenv, lib, fetchhg, pkg-config, wayland, gtk3 }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "2019-10-28";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "3fac708b2b541bb9927ec1b2389c4eb294e1b35b";
    sha256 = "0sp9hqm1lv9wyxj8z7vazs25nvl6yznd5vfhmwb51axwkr79s2ym";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland gtk3 ];

  sourceRoot = "hg-archive/Release";

  installPhase = ''
    mkdir -p $out/bin
    cp wofi $out/bin/
  '';

  meta = with lib; {
    description = "A launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ erictapen ];
    platforms = with platforms; linux;
  };
}
