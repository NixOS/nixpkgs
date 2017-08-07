{ stdenv, fetchgit, which, python2, gcc-arm-embedded, git, zip, unzip
, file, dpkg , fakeroot, breakpad, zlib, libudev, qt58, overrideCC, gcc_multi
}:

let
  # The simulator is a 32 bit executable
  stdenv_multi = overrideCC stdenv gcc_multi;

in

stdenv_multi.mkDerivation rec {
  name = "dRonin-${version}";

  version = "26-06-2017";

  src = fetchgit {
    url = "https://github.com/d-ronin/dRonin.git";
    rev = "595661cb0b3d0bce75828664e3bb84f2445066a6";
    sha256 = "0fn6jxpp854v7jf55nj3mzz965r8727p1smjkd9gn86sazkdfdhs";
    leaveDotGit = true;
  };

  # The build requires the hash of the ancestor for some reason, replace that
  # with zeros
  patches = [ ./git-hash.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    which
    python2
    gcc-arm-embedded
    git
    zip
    unzip
    file
    dpkg
    fakeroot
  ];

  buildInputs = [
    breakpad
    zlib
    libudev
  ];

  postPatch = ''
    # The simulator builds as a 32 bit executable, make the 32 bit library and
    # header available as $NIX_LDFLAGS contains only 64-bit ones.
    substituteInPlace flight/PiOS/posix/library.mk --replace '-m32' \
      '-m32 -L${stdenv_multi.cc.libc.out}/lib/32 -I${stdenv_multi.cc.libc.dev}/include'
  '';

  preBuild = ''
    mkdir -p tools
    ln -s ${gcc-arm-embedded} tools/gcc-arm-none-eabi-5_2-2015q4

    mkdir -p tools/breakpad
    ln -s ${breakpad} tools/breakpad/20170224

    mkdir -p tools/Qt5.8.0/5.8/gcc_64
    ln -s ${qt58.full}/lib/qt5/* tools/Qt5.8.0/5.8/gcc_64/
    ln -s ${qt58.full}/bin tools/Qt5.8.0/5.8/gcc_64/bin
  '';

  buildPhase = ''
    export PACKAGE_DIR="$out"
    runHook preBuild

    # The makefiles seem to be a little broken, and don't specify these
    # dependencies of package_all_compress correctly, build them explicitly
    # here
    make simulation -j $NIX_BUILD_CORES
    make gcs -j $NIX_BUILD_CORES
    make package_flight -j $NIX_BUILD_CORES

    make package_all_compress -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    cp -r build/package-linux_*-dirty/dronin_linux_*-dirty "$out"
    cp -r build/package-linux_*-dirty/rules.udev "$out"
  '';

  meta = {
    description = "An autopilot/flight controller firmware for controllers in the OpenPilot/Tau Labs family";
    longDescription = ''
      dRonin is an autopilot/flight controller firmware for controllers in the OpenPilot/Tau Labs family.
      It's aimed at a variety of use cases: acro/racing, autonomous flight, and vehicle research.
    '';
    homepage = https://dronin.org;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.expipiplus1 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
