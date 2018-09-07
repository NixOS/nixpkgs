{ stdenv, lib, lndir, makeWrapper
, fetchFromGitHub, cmake
, libusb, pkgconfig
, python, swig2, numpy, ncurses
, extraPackages ? []
} :

let
  version = "0.6.1";

in stdenv.mkDerivation {
  name = "soapysdr-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "soapy-sdr-${version}";
    sha256 = "1azbb2j6dv0b2dd5ks6yqd31j17sdhi9p82czwc8zy2isymax0l9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb ncurses numpy swig2 python ];

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
    for file in out/bin/*; do
        ${makeWrapper}/bin/wrapProgram "$file" \
            --prefix SOAPY_SDR_PLUGIN_PATH : ${lib.makeSearchPath "lib/SoapySDR/modules0.6" extraPackages}
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

