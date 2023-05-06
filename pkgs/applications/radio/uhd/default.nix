{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkg-config
# See https://files.ettus.com/manual_archive/v3.15.0.0/html/page_build_guide.html for dependencies explanations
, boost
, ncurses
, enableCApi ? true
# requires numpy
, enablePythonApi ? false
, python3
, buildPackages
, enableExamples ? false
, enableUtils ? false
, libusb1
, enableDpdk ? false
, dpdk
# Devices
, enableOctoClock ? true
, enableMpmd ? true
, enableB100 ? true
, enableB200 ? true
, enableUsrp1 ? true
, enableUsrp2 ? true
, enableX300 ? true
, enableN300 ? true
, enableN320 ? true
, enableE300 ? true
, enableE320 ? true
}:

let
  onOffBool = b: if b then "ON" else "OFF";
  inherit (lib) optionals;
  # Later used in pythonEnv generation. Python + mako are always required for the build itself but not necessary for runtime.
  pythonEnvArg = (ps: with ps; [ mako ]
    ++ optionals (enablePythonApi) [ numpy setuptools ]
    ++ optionals (enableUtils) [ requests six ]
  );
in

stdenv.mkDerivation rec {
  pname = "uhd";
  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf... style keeps changing
  version = "4.4.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "v${version}";
    sha256 = "sha256-khVOHlvacZc4EMg4m55rxEqPvLY1xURpAfOW905/3jg=";
  };
  # Firmware images are downloaded (pre-built) from the respective release on Github
  uhdImagesSrc = fetchurl {
    url = "https://github.com/EttusResearch/uhd/releases/download/v${version}/uhd-images_${version}.tar.xz";
    sha256 = "V8ldW8bvYWbrDAvpWpHcMeLf9YvF8PIruDAyNK/bru4=";
  };

  cmakeFlags = [
    "-DENABLE_LIBUHD=ON"
    "-DENABLE_USB=ON"
    "-DENABLE_TESTS=ON" # This installs tests as well so we delete them via postPhases
    "-DENABLE_EXAMPLES=${onOffBool enableExamples}"
    "-DENABLE_UTILS=${onOffBool enableUtils}"
    "-DENABLE_C_API=${onOffBool enableCApi}"
    "-DENABLE_PYTHON_API=${onOffBool enablePythonApi}"
    "-DENABLE_DPDK=${onOffBool enableDpdk}"
    # Devices
    "-DENABLE_OCTOCLOCK=${onOffBool enableOctoClock}"
    "-DENABLE_MPMD=${onOffBool enableMpmd}"
    "-DENABLE_B100=${onOffBool enableB100}"
    "-DENABLE_B200=${onOffBool enableB200}"
    "-DENABLE_USRP1=${onOffBool enableUsrp1}"
    "-DENABLE_USRP2=${onOffBool enableUsrp2}"
    "-DENABLE_X300=${onOffBool enableX300}"
    "-DENABLE_N300=${onOffBool enableN300}"
    "-DENABLE_N320=${onOffBool enableN320}"
    "-DENABLE_E300=${onOffBool enableE300}"
    "-DENABLE_E320=${onOffBool enableE320}"
  ]
    # TODO: Check if this still needed
    # ABI differences GCC 7.1
    # /nix/store/wd6r25miqbk9ia53pp669gn4wrg9n9cj-gcc-7.3.0/include/c++/7.3.0/bits/vector.tcc:394:7: note: parameter passing for argument of type 'std::vector<uhd::range_t>::iterator {aka __gnu_cxx::__normal_iterator<uhd::range_t*, std::vector<uhd::range_t> >}' changed in GCC 7.1
    ++ [ (lib.optionalString stdenv.isAarch32 "-DCMAKE_CXX_FLAGS=-Wno-psabi") ]
  ;

  pythonEnv = python3.withPackages pythonEnvArg;

  nativeBuildInputs = [
    cmake
    pkg-config
    # Present both here and in buildInputs for cross compilation.
    (buildPackages.python3.withPackages pythonEnvArg)
  ];
  buildInputs = [
    boost
    libusb1
  ]
    # However, if enableLibuhd_Python_api *or* enableUtils is on, we need
    # pythonEnv for runtime as well. The utilities' runtime dependencies are
    # handled at the environment
    ++ optionals (enableExamples) [ ncurses ncurses.dev ]
    ++ optionals (enablePythonApi || enableUtils) [ pythonEnv ]
    ++ optionals (enableDpdk) [ dpdk ]
  ;

  # many tests fails on darwin, according to ofborg
  doCheck = !stdenv.isDarwin;

  # Build only the host software
  preConfigure = "cd host";
  # TODO: Check if this still needed, perhaps relevant:
  # https://files.ettus.com/manual_archive/v3.15.0.0/html/page_build_guide.html#build_instructions_unix_arm
  patches = [
    # Disable tests that fail in the sandbox
    ./no-adapter-tests.patch
  ];

  postPhases = [ "installFirmware" "removeInstalledTests" ]
    ++ optionals (enableUtils && stdenv.targetPlatform.isLinux) [ "moveUdevRules" ]
  ;

  # UHD expects images in `$CMAKE_INSTALL_PREFIX/share/uhd/images`
  installFirmware = ''
    mkdir -p "$out/share/uhd/images"
    tar --strip-components=1 -xvf "${uhdImagesSrc}" -C "$out/share/uhd/images"
  '';

  # -DENABLE_TESTS=ON installs the tests, we don't need them in the output
  removeInstalledTests = ''
    rm -r $out/lib/uhd/tests
  '';

  # Moves the udev rules to the standard location, needed only if utils are
  # enabled
  moveUdevRules = ''
    mkdir -p $out/lib/udev/rules.d
    mv $out/lib/uhd/utils/uhd-usrp.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "USRP Hardware Driver (for Software Defined Radio)";
    longDescription = ''
      The USRP Hardware Driver (UHD) software is the hardware driver for all
      USRP (Universal Software Radio Peripheral) devices.

      USRP devices are designed and sold by Ettus Research, LLC and its parent
      company, National Instruments.
    '';
    homepage = "https://uhd.ettus.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz tomberek doronbehar ];
  };
}
