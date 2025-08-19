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

stdenv.mkDerivation rec {
  pname = "${lib.optionalString withNgshared "lib"}ngspice";
  version = "44.2";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    hash = "sha256-59rft71UdP0iQJweWmes3sGfd+WX32jhfFVJvBOQ1/0=";
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

  meta = with lib; {
    description = "Next Generation Spice (Electronic Circuit Simulator)";
    mainProgram = "ngspice";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [
      bsd3
      gpl2Plus
      lgpl2Plus
    ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
