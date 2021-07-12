{ stdenv, lib, lndir, makeWrapper
, fetchFromGitHub, cmake
, libusb-compat-0_1, pkg-config
, usePython ? false
, python, ncurses, swig2
, extraPackages ? []
} :

let

  version = "0.8.0";
  modulesVersion = with lib; versions.major version + "." + versions.minor version;
  modulesPath = "lib/SoapySDR/modules" + modulesVersion;
  extraPackagesSearchPath = lib.makeSearchPath modulesPath extraPackages;

in stdenv.mkDerivation {
  pname = "soapysdr";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "soapy-sdr-${version}";
    sha256 = "1dy25zxk7wmg7ik82dx7h3bbbynvalbz1dxsl7kgm3374yxhnixv";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];
  buildInputs = [ libusb-compat-0_1 ncurses ]
    ++ lib.optionals usePython [ python swig2 ];

  propagatedBuildInputs = lib.optional usePython python.pkgs.numpy;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ] ++ lib.optional usePython "-DUSE_PYTHON_CONFIG=ON";

  postFixup = lib.optionalString (lib.length extraPackages != 0) ''
    # Join all plugins via symlinking
    for i in ${toString extraPackages}; do
      ${lndir}/bin/lndir -silent $i $out
    done
    # Needed for at least the remote plugin server
    for file in $out/bin/*; do
        wrapProgram "$file" --prefix SOAPY_SDR_PLUGIN_PATH : ${extraPackagesSearchPath}
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapySDR";
    description = "Vendor and platform neutral SDR support library";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}
