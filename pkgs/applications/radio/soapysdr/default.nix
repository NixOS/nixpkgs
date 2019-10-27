{ stdenv, lib, lndir, makeWrapper
, fetchFromGitHub, cmake
, libusb, pkgconfig
, python, swig2, numpy, ncurses
, extraPackages ? []
} :

let

  version = "0.7.1";
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
    sha256 = "1rbnd3w12kzsh94fiywyn4vch7h0kf75m88fi6nq992b3vnmiwvl";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];
  buildInputs = [ libusb ncurses numpy python swig2 ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_PYTHON_CONFIG=ON"
  ];

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

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapySDR;
    description = "Vendor and platform neutral SDR support library";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}
