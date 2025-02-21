{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  libusb-compat-0_1,
  ncurses,
  usePython ? false,
  python ? null,
  swig,
  extraPackages ? [ ],
  buildPackages,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapysdr";
  # Don't forget to change passthru.abiVersion
  version = "0.8.1-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";

    # Instead of applying several patches for Python 3.12 compat, just take the latest, from:
    # use old get python lib for v2 (#437)
    rev = "309335ec6a52eb712387ed025d705a3c0f7a1e24";
    hash = "sha256-a9414gX4fUAPQaKKqrWgSlFHZH0BWqbgHzhVCKnIn2M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs =
    [
      libusb-compat-0_1
      ncurses
    ]
    ++ lib.optionals usePython [
      python
      swig
    ];

  propagatedBuildInputs = lib.optionals usePython [ python.pkgs.numpy ];

  cmakeFlags = lib.optionals usePython [ "-DUSE_PYTHON_CONFIG=ON" ];

  postFixup = lib.optionalString (extraPackages != [ ]) (
    # Join all plugins via symlinking
    lib.pipe extraPackages [
      (map (pkg: ''
        ${buildPackages.xorg.lndir}/bin/lndir -silent ${pkg} $out
      ''))
      lib.concatStrings
    ]
    + ''
      # Needed for at least the remote plugin server
      for file in $out/bin/*; do
          wrapProgram "$file" --prefix SOAPY_SDR_PLUGIN_PATH : ${lib.escapeShellArg (lib.makeSearchPath finalAttrs.passthru.searchPath extraPackages)}
      done
    ''
  );

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    # SOAPY_SDR_ABI_VERSION defined in include/SoapySDR/Version.h
    abiVersion = "0.8-3";
    searchPath = "lib/SoapySDR/modules${finalAttrs.passthru.abiVersion}";
  };

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapySDR";
    description = "Vendor and platform neutral SDR support library";
    license = licenses.boost;
    maintainers = with maintainers; [
      markuskowa
      numinit
    ];
    mainProgram = "SoapySDRUtil";
    pkgConfigModules = [ "SoapySDR" ];
    platforms = platforms.unix;
  };
})
