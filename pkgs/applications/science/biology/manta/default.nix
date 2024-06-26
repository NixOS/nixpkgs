{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  python2,
}:

stdenv.mkDerivation rec {
  pname = "manta";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "manta";
    rev = "v${version}";
    sha256 = "1711xkcw8rpw9xv3bbm7v1aryjz4r341rkq5255192dg38sgq7w2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    python2
  ];
  postFixup = ''
    sed -i 's|/usr/bin/env python2|${python2.interpreter}|' $out/lib/python/makeRunScript.py
    sed -i 's|/usr/bin/env python|${python2.interpreter}|' $out/lib/python/pyflow/pyflow.py
    sed -i 's|/bin/bash|${stdenv.shell}|' $out/lib/python/pyflow/pyflowTaskWrapper.py
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    rm $out/lib/python/**/*.pyc
    PYTHONPATH=$out/lib/python:$PYTHONPATH python -c 'import makeRunScript'
    PYTHONPATH=$out/lib/python/pyflow:$PYTHONPATH python -c 'import pyflowTaskWrapper; import pyflow'
  '';

  meta = with lib; {
    description = "Structural variant caller";
    license = licenses.gpl3;
    homepage = "https://github.com/Illumina/manta";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
