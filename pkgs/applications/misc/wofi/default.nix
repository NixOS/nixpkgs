{ stdenv, lib, fetchhg, fetchpatch, pkg-config, meson, ninja, wayland, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.1.2";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = "v${version}";
    sha256 = "086j5wshawjbwdmmmldivfagc2rr7g5a2gk11l0snqqslm294xsn";
  };

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook ];
  buildInputs = [ wayland gtk3 ];

  # Fixes icon bug on NixOS.
  # Will need to be removed on next release
  # see https://todo.sr.ht/~scoopta/wofi/54
  patches = [
    (fetchpatch {
      url = "https://paste.sr.ht/blob/1cbddafac3806afb203940c029e78ce8390d8f49";
      sha256 = "18960y9ajilrwwl6mjnrh6wj0sm4ivczmacck36p2dj9xd0n8vkh";
    })
  ];

  meta = with lib; {
    description = "A launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ erictapen ];
    platforms = with platforms; linux;
  };
}
