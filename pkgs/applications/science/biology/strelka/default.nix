{lib, stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, python2}:

stdenv.mkDerivation rec {
  pname = "strelka";
  version = "2.9.10";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "strelka";
    rev = "v${version}";
    sha256 = "1nykbmim1124xh22nrhrsn8xgjb3s2y7akrdapn9sl1gdych4ppf";
  };

  patches = [
    # Pull pending fix for gcc-12:
    #   https://github.com/Illumina/strelka/pull/204
    (fetchpatch {
      name = "limits.patch";
      url = "https://github.com/Illumina/strelka/commit/98272cd345c6e4c672e6a5b7721204fcac0502d6.patch";
      sha256 = "16dx5b4x3xa0dvqggv749l863m114fad9y85z4czr7pnvnw65h56";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python2 ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=pessimizing-move"
  ];

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

  meta = with lib; {
    description = "Germline and small variant caller";
    license = licenses.gpl3;
    homepage = "https://github.com/Illumina/strelka";
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };

}
