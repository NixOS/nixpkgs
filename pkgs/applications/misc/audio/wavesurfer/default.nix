{ stdenv, fetchurl, snack, tcl, tk, makeWrapper }:

stdenv.mkDerivation {
  name = "wavesurfer-1.8.8p5";

  src = fetchurl {
    url = mirror://sourceforce/wavesurfer/wavesurfer/1.8.8p5/wavesurfer-1.8.8p5-src.tgz;
    sha256 = "06k1zg7pkz67c9k99hqa0mbx2pd4nyfw3jax93vp04fx8w8hcmmf";
  };

  buildInputs = [ snack tcl tk makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,nix-support,share/wavesurfer/}
    mv doc $out/share/wavesurfer
    mv * $out/nix-support
    ln -s $out/{nix-support/src/app-wavesurfer,bin}/wavesurfer.tcl
    chmod +x "$out/nix-support/src/app-wavesurfer/wavesurfer.tcl"
    wrapProgram "$out/nix-support/src/app-wavesurfer/wavesurfer.tcl"  \
                 --set TCLLIBPATH "${snack}/lib" \
                 --prefix PATH : "${stdenv.lib.makeBinPath [ tcl tk ]}"
  '';

  meta = { 
    description = "Tool for recording, playing, editing, viewing and labeling of audio";
    homepage = http://www.speech.kth.se/wavesurfer/;
    license = "BSD";
  };
}
