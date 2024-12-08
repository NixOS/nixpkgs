{ lib, stdenv, fetchFromGitHub, libusb1, pkg-config, pmutils, udev} :

let
  version = "2.1.1";
  daemonlib = fetchFromGitHub {
    owner = "Tinkerforge";
    repo = "daemonlib";
    rev = "brickd-${version}";
    sha256 = "sha256-0HhuC4r1S4NJa2FSJa7+fNCfcoRTBckikYbGSE+2FbE=";
  };
in

stdenv.mkDerivation {
  pname = "brickd";
  inherit version;

  src = fetchFromGitHub {
    owner = "Tinkerforge";
    repo = "brickd";
    rev = "v${version}";
    sha256 = "sha256-6w2Ew+dLMmdRf9CF3TdKHa0d5ZgmX5lKIR+5t3QAWFQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 pmutils udev ];

  # shell thing didn't work so i replaced it using nix
  prePatch = ''
    substituteInPlace src/brickd/Makefile --replace 'PKG_CONFIG := $(shell which pkg-config 2> /dev/null)' "PKG_CONFIG := $pkgconfig/bin/pkg_config";
  '';

  buildPhase = ''
    # build the brickd binary
    mkdir src/daemonlib
    cp -r ${daemonlib}/* src/daemonlib
    substituteInPlace src/daemonlib/utils.{c,h} \
      --replace "_GNU_SOURCE" "__GLIBC__"
    cd src/brickd
    make

    # build and execute the unit tests
    cd ../tests
    make
    for i in array_test base58_test node_test putenv_test queue_test sha1_test; do
      echo "running unit test $i:"
      ./$i
    done
  '';

  installPhase = ''
    cd ../brickd
    mkdir -p $out/bin
    cp brickd $out/bin/brickd
  '';

  meta = {
    homepage = "https://www.tinkerforge.com/";
    description = "Daemon (or service on Windows) that acts as a bridge between the Bricks/Bricklets and the API bindings for the different programming languages";
    maintainers = [ lib.maintainers.qknight ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "brickd";
  };
}
