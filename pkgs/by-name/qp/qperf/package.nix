{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  perl,
  rdma-core,
}:

stdenv.mkDerivation rec {
  pname = "qperf";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "qperf";
    rev = "v${version}";
    hash = "sha256-x9l8xqwMDHlXRZpWt3XiqN5xyCTV5rk8jp/ClRPPECI=";
  };

  patches = [
    (fetchpatch {
      name = "version-bump.patch";
      url = "https://github.com/linux-rdma/qperf/commit/34ec57ddb7e5ae1adfcfc8093065dff90b69a275.patch";
      hash = "sha256-+7ckhUUB+7BG6qRKv0wgyIxkyvll2xjf3Wk1hpRsDo0=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    perl
    rdma-core
  ];
  buildInputs = [ rdma-core ];

  postUnpack = ''
    patchShebangs .
  '';

  configurePhase = ''
    runHook preConfigure
    ./autogen.sh
    ./configure --prefix=$out
    runHook postConfigure
  '';

  meta = with lib; {
    description = "Measure RDMA and IP performance";
    mainProgram = "qperf";
    homepage = "https://github.com/linux-rdma/qperf";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
