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
  version = "0.8.1-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "1551ea0d39ce546b32a15808b9b1241018a89fc8";
    hash = "sha256-k1ocvnkgmucewWeUgj7hY8hj9gOBl3G2iH9KM2h/Sck=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
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
        ${buildPackages.lndir}/bin/lndir -silent ${pkg} $out
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

  meta = {
    homepage = "https://github.com/pothosware/SoapySDR";
    description = "Vendor and platform neutral SDR support library";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      markuskowa
      numinit
    ];
    mainProgram = "SoapySDRUtil";
    pkgConfigModules = [ "SoapySDR" ];
    platforms = lib.platforms.unix;
  };
})
