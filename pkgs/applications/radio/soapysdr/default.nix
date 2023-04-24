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

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "soapy-sdr-${version}";
    sha256 = "19f2x0pkxvf9figa0pl6xqlcz8fblvqb19mcnj632p0l8vk6qdv2";
  };

  patches = [
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
