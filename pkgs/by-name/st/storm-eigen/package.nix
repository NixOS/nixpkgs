{
  lib,
  stdenv,
  eigen,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "storm-eigen";
  version = "3.4.1-alpha";

  src = eigen.src;

  patches = [
    (fetchpatch {
      name = "eigen341alpha.patch";
      url = "https://raw.githubusercontent.com/moves-rwth/storm/c7448a2ee1c4db5d4bd892995768fa790247511b/resources/3rdparty/patches/eigen341alpha.patch";
      hash = "sha256-T/PrXGHxmGtZzUJxL3FgDIWh3ViuPRJtdzDs/M3L6eQ=";
    })
  ];

  installPhase = ''
    mkdir -p $out/include/eigen3
    cp -r Eigen $out/include/eigen3/
    cp -r unsupported $out/include/eigen3/
  '';

  meta = {
    description = "Eigen library with patches for Storm probabilistic model checker";
    homepage = "https://eigen.tuxfamily.org/";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.astrobeastie ];
    platforms = lib.platforms.all;
    longDescription = ''
      A patched version of the Eigen C++ template library for linear algebra
      specifically modified for compatibility with the Storm probabilistic model checker.
    '';
  };
})
