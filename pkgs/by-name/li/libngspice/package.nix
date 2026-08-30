{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  fftw,
  withNgshared ? true,
  libxaw,
  libxext,
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

  patches = [
    (builtins.toFile "fix-cppduals.patch" ''
      --- a/src/include/cppduals/duals/dual
      +++ b/src/include/cppduals/duals/dual
      @@ -485,10 +485,6 @@ struct is_arithmetic<duals::dual<T>> : is_arithmetic<T> {};

       #endif // CPPDUALS_ENABLE_IS_ARITHMETIC

      -/// Duals are compound types.
      -template <class T>
      -struct is_compound<duals::dual<T>> : true_type {};
      -
       // Modification of std::numeric_limits<> per
       // C++03 17.4.3.1/1, and C++11 18.3.2.3/1.
       template <class T>
    '')
  ];

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [
    fftw
    readline
  ]
  ++ lib.optionals (!withNgshared) [
    libxaw
    libxext
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
