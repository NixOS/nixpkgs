{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumptorrent";
  version = "1.2";

  src = fetchurl {
    url = "mirror://sourceforge/dumptorrent/dumptorrent-${finalAttrs.version}.tar.gz";
    sha256 = "073h03bmpfdy15qh37lvppayld2747i4acpyk0pm5nf2raiak0zm";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "gcc" "$CC"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./dumptorrent $out/bin
  '';

  meta = {
    description = "Dump .torrent file information";
    homepage = "https://sourceforge.net/projects/dumptorrent/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.zohl ];
    platforms = lib.platforms.all;
    mainProgram = "dumptorrent";
  };
})
