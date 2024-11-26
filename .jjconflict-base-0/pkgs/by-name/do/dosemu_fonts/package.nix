{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontdir,
  mkfontscale,
}:

stdenv.mkDerivation rec {
  pname = "dosemu-fonts";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/dosemu/dosemu-${version}.tgz";
    sha256 = "0l1zwmw42mpakjrzmbygshcg2qzq9mv8lx42738rz3j9hrqzg4pw";
  };

  buildCommand = ''
    tar xf "$src" --anchored --wildcards '*/etc/*.bdf' '*/etc/dosemu.alias'
    fontPath="$out/share/fonts/X11/misc/dosemu"
    mkdir -p "$fontPath"
    for i in */etc/*.bdf; do
      fontOut="$out/share/fonts/X11/misc/dosemu/$(basename "$i" .bdf).pcf.gz"
      echo -n "Installing font $fontOut..." >&2
      ${bdftopcf}/bin/bdftopcf $i | gzip -c -9 -n > "$fontOut"
      echo " done." >&2
    done
    cp */etc/dosemu.alias "$fontPath/fonts.alias"
    cd "$fontPath"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1miqv0ral5vazx721wildjlzvji5r7pbgm39c0cpj5ywafaikxr8";

  meta = {
    description = "Various fonts from the DOSEmu project";
    license = lib.licenses.gpl2Only;
  };
}
