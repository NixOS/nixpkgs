{ stdenv, fetchurl, pkgconfig, libjack2, fftwFloat, gtk2 }:

stdenv.mkDerivation rec {
  name = "spectrojack-${version}";
  version = "0.4";

  src = fetchurl {
    url = "http://sed.free.fr/spectrojack/${name}.tar.gz";
    sha256 = "0p5aa55hnazv5djw0431mza068h7mjkb9pnglxfpqkx5z0czisdx";
  };
  buildInputs = [ pkgconfig libjack2 fftwFloat gtk2 ];
  configurePhase= ''
    sed -i 's/.*home.*/#&/' ./Makefile
    substituteInPlace ./Makefile \
      --replace "/usr/share" "$out/usr/share"
  '';
  installPhase= ''
    install -Dm755 spectrojack $out/bin/spectrojack
    install -Dm644 spectrojack_icon.svg $out/usr/share/spectrojack/icon.svg
    install -Dm644 -t $out/usr/share/spectrojack/colormaps colormaps/*
  '';

  meta = {
    description = "A little spectrogram/audiogram/sonogram/whatever for JACK";
    homepage = http://sed.free.fr/spectrojack;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [ sleexyz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
