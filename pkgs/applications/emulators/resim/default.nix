{ fetchFromGitHub, lib, stdenv, cmake, qt4 }:

stdenv.mkDerivation {
  pname = "resim";
  version = "unstable-2016-11-11";
  src = fetchFromGitHub {
    owner = "itszor";
    repo = "resim";
    rev = "cdc7808ceb7ba4ac00d0d08ca646b58615059150";
    sha256 = "1743lngqxd7ai4k6cd4d1cf9h60z2pnvr2iynfs1zlpcj3w1hx0c";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];
  installPhase = ''
    mkdir -pv $out/{lib,bin}
    cp -v libresim/libarmsim.so $out/lib/libarmsim.so
    cp -v vc4emul/vc4emul $out/bin/vc4emul
  '';

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta.license = lib.licenses.mit;
}
