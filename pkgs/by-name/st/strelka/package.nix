{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  zlib,
  python2,
}:

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
      hash = "sha256-psBiuN32nvwZ+QX51JQjIdRhEE3k7PfwbkD10ckqvZk=";
    })
  ];

  postPatch = ''
    substituteInPlace src/cmake/boost.cmake \
      --replace "1.58.0" "${boost.version}" \
      --replace "Boost_USE_STATIC_LIBS ON" "Boost_USE_STATIC_LIBS OFF"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    zlib
    python2
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=14"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
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
    platforms = platforms.linux;
  };

}
