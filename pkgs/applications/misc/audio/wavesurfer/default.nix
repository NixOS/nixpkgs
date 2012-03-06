{ stdenv, fetchurl, snack, tcl, tk, makeWrapper }:

stdenv.mkDerivation {
  name = "wavesurfer-1.8.5";

  src = fetchurl {
    url = http://www.speech.kth.se/wavesurfer/wavesurfer-1.8.5.tar.gz;
    sha256 = "1yx9s1j47cq0v40cwq2gn7bdizpw46l95ba4zl9z4gg31mfvm807";
  };

  buildInputs = [ snack tcl tk makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,nix-support,share/wavesurfer/}
    mv doc $out/share/wavesurfer
    mv * $out/nix-support
    ln -s $out/{nix-support,bin}/wavesurfer.tcl
    wrapProgram "$out/nix-support/wavesurfer.tcl"  \
                 --set TCLLIBPATH "${snack}/lib" \
                 --prefix PATH : "${tcl}/bin:${tk}/bin"
  '';

  meta = { 
    description = "Tool for recording, playing, editing, viewing and labeling of audio";
    homepage = http://www.speech.kth.se/wavesurfer/;
    license = "BSD";
  };
}
