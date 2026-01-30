{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  fftw,
  withNgshared ? true,
  libXaw,
  libXext,
  llvmPackages,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "${lib.optionalString withNgshared "lib"}ngspice";
  version = "45";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${finalAttrs.version}.tar.gz";
    hash = "sha256-8arYq6woKKe3HaZkEd6OQGUk518wZuRnVUOcSQRC1zQ=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [
    fftw
    readline
  ]
  ++ lib.optionals (!withNgshared) [
    libXaw
    libXext
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  configureFlags =
    lib.optionals withNgshared [
      "--with-ngshared"
    ]
    ++ [
      "--enable-xspice"
      "--enable-cider"
      "--enable-osdi"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "Next Generation Spice (Electronic Circuit Simulator)";
    mainProgram = "ngspice";
    homepage = "http://ngspice.sourceforge.net";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
      lgpl2Plus
    ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with lib.maintainers; [ bgamari ];
    platforms = lib.platforms.unix;
  };
})
