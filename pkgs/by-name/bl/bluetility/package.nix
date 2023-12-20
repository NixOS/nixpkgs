{ lib
, fetchzip
}:

fetchzip rec {
  pname = "bluetility";
  version = "1.5.1";

  url = "https://github.com/jnross/Bluetility/releases/download/${version}/Bluetility.app.zip";
  hash = "sha256-QNZR2yYIHMlD71tA1iPCh0EsaRKvZCR+f6/ZxUMRhN8=";

  stripRoot = false;

  postFetch = ''
    shopt -s extglob
    mkdir $out/Applications
    mv $out/!(Applications) $out/Applications
  '';

  meta = with lib; {
    description = "Bluetooth Low Energy browse";
    homepage = "https://github.com/jnross/Bluetility";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
}
