{ lib, stdenv, fetchurl, snack, tcl, tk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "wavesurfer";
  version = "1.8.5";

  src = fetchurl {
    url = "https://www.speech.kth.se/wavesurfer/wavesurfer-${version}.tar.gz";
    sha256 = "1yx9s1j47cq0v40cwq2gn7bdizpw46l95ba4zl9z4gg31mfvm807";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ snack tcl tk ];

  installPhase = ''
    mkdir -p $out/{bin,nix-support,share/wavesurfer/}
    mv doc $out/share/wavesurfer
    mv * $out/nix-support
    ln -s $out/{nix-support,bin}/wavesurfer.tcl
    wrapProgram "$out/nix-support/wavesurfer.tcl"  \
                 --set TCLLIBPATH "${snack}/lib" \
                 --prefix PATH : "${lib.makeBinPath [ tcl tk ]}"
  '';

  meta = {
    description = "Tool for recording, playing, editing, viewing and labeling of audio";
    homepage = "https://www.speech.kth.se/wavesurfer/";
    license = lib.licenses.bsd0;
  };
}
