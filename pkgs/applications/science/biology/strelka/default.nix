{stdenv, fetchFromGitHub, cmake, zlib, python2}:

stdenv.mkDerivation rec {
  name = "strelka-${version}";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "strelka";
    rev = "v${version}";
    sha256 = "0x4a6nkx1jnyag9svghsdjz1fz6q7qx5pn77wphdfnk81f9yspf8";
  };

  buildInputs = [ cmake zlib python2 ];

  preConfigure = ''
    sed -i 's|/usr/bin/env python|${python2}/bin/python|' src/python/lib/makeRunScript.py
    patchShebangs .
  '';

  postFixup = ''
    pushd $out/lib/python/pyflow
    sed -i 's|/bin/bash|${stdenv.shell}|' pyflowTaskWrapper.py
    rm pyflowTaskWrapper.pyc
    echo "import pyflowTaskWrapper" | python2
    popd
  '';

  meta = with stdenv.lib; {
    description = "Germline and small variant caller";
    license = licenses.gpl3;
    homepage = https://github.com/Illumina/strelka;
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };

}
