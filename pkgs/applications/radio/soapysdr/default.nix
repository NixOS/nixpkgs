<<<<<<< HEAD
{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, makeWrapper
, libusb-compat-0_1
, ncurses
, usePython ? false
, python ? null
, swig2
, extraPackages ? [ ]
, buildPackages
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapysdr";
  version = "0.8.1";
=======
{ stdenv, lib, lndir, makeWrapper
, fetchFromGitHub, cmake
, libusb-compat-0_1, pkg-config
, usePython ? false
, python ? null
, ncurses, swig2
, extraPackages ? []
, testers
, buildPackages
}:

let

  version = "0.8.1";
  modulesVersion = with lib; versions.major version + "." + versions.minor version;
  modulesPath = "lib/SoapySDR/modules" + modulesVersion;
  extraPackagesSearchPath = lib.makeSearchPath modulesPath extraPackages;

in stdenv.mkDerivation (finalAttrs: {
  pname = "soapysdr";
  inherit version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
<<<<<<< HEAD
    rev = "soapy-sdr-${finalAttrs.version}";
=======
    rev = "soapy-sdr-${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "19f2x0pkxvf9figa0pl6xqlcz8fblvqb19mcnj632p0l8vk6qdv2";
  };

  patches = [
<<<<<<< HEAD
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
  buildInputs = [
    libusb-compat-0_1
    ncurses
  ] ++ lib.optionals usePython [
    python
    swig2
  ];

  propagatedBuildInputs = lib.optionals usePython [
    python.pkgs.numpy
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ] ++ lib.optionals usePython [
    "-DUSE_PYTHON_CONFIG=ON"
  ];

  postFixup = lib.optionalString (extraPackages != [ ]) (
    # Join all plugins via symlinking
    lib.pipe extraPackages [
      (map (pkg: ''
        ${buildPackages.xorg.lndir}/bin/lndir -silent ${pkg} $out
      ''))
      lib.concatStrings
    ] + ''
      # Needed for at least the remote plugin server
      for file in $out/bin/*; do
          wrapProgram "$file" --prefix SOAPY_SDR_PLUGIN_PATH : ${lib.escapeShellArg (
            lib.makeSearchPath finalAttrs.passthru.searchPath extraPackages
          )}
      done
    ''
  );

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    searchPath = "lib/SoapySDR/modules${lib.versions.majorMinor finalAttrs.version}";
  };
=======
    # see https://github.com/pothosware/SoapySDR/issues/352 for upstream issue
    ./fix-pkgconfig.patch
  ];

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];
  buildInputs = [ libusb-compat-0_1 ncurses ]
    ++ lib.optionals usePython [ python swig2 ];

  propagatedBuildInputs = lib.optional usePython python.pkgs.numpy;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ] ++ lib.optional usePython "-DUSE_PYTHON_CONFIG=ON";

  # https://github.com/pothosware/SoapySDR/issues/352
  postPatch = ''
    substituteInPlace lib/SoapySDR.in.pc \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postFixup = lib.optionalString (lib.length extraPackages != 0) ''
    # Join all plugins via symlinking
    for i in ${toString extraPackages}; do
      ${buildPackages.xorg.lndir}/bin/lndir -silent $i $out
    done
    # Needed for at least the remote plugin server
    for file in $out/bin/*; do
        wrapProgram "$file" --prefix SOAPY_SDR_PLUGIN_PATH : ${lib.escapeShellArg extraPackagesSearchPath}
    done
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
