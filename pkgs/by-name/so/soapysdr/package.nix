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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    tag = "soapy-sdr-${finalAttrs.version}";
    hash = "sha256-Xulk079m/PEe8LvBU/LWhuSrdCEbckpSPw0GoLKTGhs=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
    abiVersion = "0.9";
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
