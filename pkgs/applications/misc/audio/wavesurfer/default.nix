args:
args.stdenv.mkDerivation {
  name = "wavesurfer-1.8.5";

  src = args.fetchurl {
    url = http://www.speech.kth.se/wavesurfer/wavesurfer-1.8.5.tar.gz;
    sha256 = "1yx9s1j47cq0v40cwq2gn7bdizpw46l95ba4zl9z4gg31mfvm807";
  };

  buildInputs =(with args; [snack tcl tk makeWrapper]);

  installPhase = ''
    ensureDir $out/{bin,nix-support,share/wavesurfer/}
    mv doc $out/share/wavesurfer
    mv * $out/nix-support
    ln -s $out/{nix-support,bin}/wavesurfer.tcl
    wrapProgram "$out/nix-support/wavesurfer.tcl"  \
                 --set TCLLIBPATH "${args.snack}/lib" \
                 --prefix PATH : "${args.tcl}/bin:${args.tk}/bin"
  '';

  meta = { 
      description = "tool for recording, playing, editing, viewing and labeling of audio";
      homepage = http://www.speech.kth.se/wavesurfer/;
      license = "BSD";
  };
}
