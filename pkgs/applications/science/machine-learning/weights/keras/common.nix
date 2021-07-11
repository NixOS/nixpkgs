{ stdenvNoCC, fetchurl, model, version, weights, sha256 }:

stdenvNoCC.mkDerivation rec {
  inherit version;
  name = "${model}-${version}";
  src = fetchurl {
    inherit sha256;
    url = "https://github.com/keras-team/keras-applications/releases/download/${model}/${weights}";
  };
  installPhase = ''
    ln -s "${src}" "$out"
  '';
  phases = [ "installPhase" ];
  meta = with stdenvNoCC.lib; {
    homepage = "https://github.com/keras-team/keras-applications";
    description = "Keras ${name} weights";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
