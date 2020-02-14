{ stdenv, lib, lndir, makeWrapper
, fetchFromGitHub, cmake
, libusb, pkgconfig
, usePython ? false
, python, ncurses, swig2
, extraPackages ? []
} :

let

  version = "0.7.2";
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
    sha256 = "102wnpjxrwba20pzdh1vvx0yg1h8vqd8z914idxflg9p14r6v5am";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];
  buildInputs = [ libusb ncurses ]
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

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapySDR;
    description = "Vendor and platform neutral SDR support library";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}
