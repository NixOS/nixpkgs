{ lib, stdenv, fetchurl, pkg-config, libjack2, fftwFloat, gtk2 }:

stdenv.mkDerivation rec {
  pname = "spectrojack";
  version = "0.4.1";

  src = fetchurl {
    url = "http://sed.free.fr/spectrojack/${pname}-${version}.tar.gz";
    sha256 = "1kiwx0kag7kq7rhg0bvckfm8r7pqmbk76ppa39cq2980jb5v8rfp";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjack2 fftwFloat gtk2 ];
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
    description = "Little spectrogram/audiogram/sonogram/whatever for JACK";
    homepage = "http://sed.free.fr/spectrojack";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ sleexyz ];
    platforms = with lib.platforms; linux;
    mainProgram = "spectrojack";
  };
}
