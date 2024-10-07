{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "soapy-sdr-${finalAttrs.version}";
    sha256 = "19f2x0pkxvf9figa0pl6xqlcz8fblvqb19mcnj632p0l8vk6qdv2";
  };

  patches = [
    # Fix for https://github.com/pothosware/SoapySDR/issues/352
    (fetchpatch {
      url = "https://github.com/pothosware/SoapySDR/commit/10c05b3e52caaa421147d6b4623eccd3fc3be3f4.patch";
      hash = "sha256-D7so6NSZiU6SXbzns04Q4RjSZW0FJ+MYobvvVpVMjws=";
    })
  ];

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
    searchPath = "lib/SoapySDR/modules${lib.versions.majorMinor finalAttrs.version}";
  };

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapySDR";
    description = "Vendor and platform neutral SDR support library";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    mainProgram = "SoapySDRUtil";
    pkgConfigModules = [ "SoapySDR" ];
    platforms = platforms.unix;
  };
})
