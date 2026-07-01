{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  swig,
  autoconf,
  automake,
  gd,
  ncurses,
  python311,
  libxml2,
  tcl,
  libusb-compat-0_1,
  pkg-config,
  boost,
  libtool,
  pythonBindings ? true,
  tclBindings ? true,
  perlBindings ? stdenv.buildPlatform == stdenv.hostPlatform,
  buildPackages,
}:
let
  python3 = python311; # needs distutils and imp
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hamlib";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "Hamlib";
    repo = "Hamlib";
    tag = "${finalAttrs.version}";
    hash = "sha256-nI8gDACxlci2Q9V2W4D1DYDUL74JwlCs+qyyNkXOPu4=";
  };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    swig
    pkg-config
    libtool
    autoconf
    automake
  ]
  ++ lib.optionals pythonBindings [ python3 ]
  ++ lib.optionals tclBindings [ tcl ]
  ++ lib.optionals perlBindings [ perl ];

  buildInputs = [
    gd
    libxml2
    libusb-compat-0_1
    boost
  ]
  ++ lib.optionals pythonBindings [
    python3
    ncurses
  ]
  ++ lib.optionals tclBindings [ tcl ];

  preConfigure = ''
    echo "Bootstrapping the hamlib"
    ./bootstrap
  '';

  configureFlags = [
    "CC_FOR_BUILD=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals perlBindings [ "--with-perl-binding" ]
  ++ lib.optionals tclBindings [
    "--with-tcl-binding"
    "--with-tcl=${tcl}/lib/"
  ]
  ++ lib.optionals pythonBindings [ "--with-python-binding" ];

  meta = {
    description = "Runtime library to control radio transceivers and receivers";
    longDescription = ''
      Hamlib provides a standardized programming interface that applications
      can use to send the appropriate commands to a radio.

      Also included in the package is a simple radio control program 'rigctl',
      which lets one control a radio transceiver or receiver, either from
      command line interface or in a text-oriented interactive interface.
    '';
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    homepage = "https://hamlib.sourceforge.net";
    maintainers = with lib.maintainers; [
      relrod
      fstracke
    ];
    platforms = with lib.platforms; unix;
  };
})
