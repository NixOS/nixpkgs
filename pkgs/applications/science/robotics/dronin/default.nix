{ stdenv, fetchgit, which, python3, gcc-arm-embedded, git, zip, unzip
, file, dpkg , fakeroot, zlib, libudev, qt59, overrideCC, gcc_multi
, breakpad, qbs, lib, qtcreator
}:

let
  # The simulator is a 32 bit executable
  stdenv_multi = overrideCC stdenv gcc_multi;

  qt = with qt59;
       env "qt-dronin-${qtbase.version}" [
         qtimageformats
         qttools # for lrelease
         qtcharts
         qtdeclarative
         qtmultimedia
         qtxmlpatterns
         qtserialport
         qtsvg
       ];

in

stdenv_multi.mkDerivation rec {
  name = "dRonin-${version}";

  version = "2018-06-30";

  src =
    fetchgit {
      url = "https://github.com/d-ronin/dRonin.git";
      rev = "3a866925d6148e33e0620c94c5940413574a7247";
      sha256 = "0nf5sg6f645nv9mhs7r6bvc2fq4slvhkpi4wvchw0cmz7sq4yd90";
      leaveDotGit = true;
    };

  # The build requires the hash of the ancestor for some reason, replace that
  # with zeros
  # Also use our version of Qt
  patches = [ ./git-hash.patch ./qt-version.patch ];

  GCS_BUILD_CONF = "release";
  FLIGHT_BUILD_CONF = "release";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    which
    python3
    gcc-arm-embedded
    git
    zip
    unzip
    file
    dpkg
    fakeroot
  ];

  buildInputs = [
    zlib
    libudev
    breakpad
    qt59.qtbase
    qt59.qtserialport
    qt59.qtsvg
  ];

  postPatch = ''
    # The simulator builds as a 32 bit executable, make the 32 bit library and
    # header available as $NIX_LDFLAGS contains only 64-bit ones.
    substituteInPlace flight/PiOS/posix/library.mk --replace '-m32' \
      '-m32 -L${stdenv_multi.cc.libc.out}/lib/32 -I${stdenv_multi.cc.libc.dev}/include'

    patchShebangs .
  '';

  preBuild = ''
    mkdir -p tools
    ln -s ${gcc-arm-embedded} tools/gcc-arm-none-eabi-6-2017-q2-update

    mkdir -p tools/breakpad
    ln -s ${breakpad} tools/breakpad/20170922

    mkdir -p tools/Qt5.9.3/5.9.3/gcc_64
    mkdir -p tools/Qt5.9.3/Tools
    ln -s ${qt}/lib/qt-5.9/* tools/Qt5.9.3/5.9.3/gcc_64/
    ln -s ${qt}/bin tools/Qt5.9.3/5.9.3/gcc_64/bin
    ln -s ${qtcreator} tools/Qt5.9.3/Tools/QtCreator
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

    make package_all_compress
  '';

  installPhase = ''
    cp -r ./build/package-linux_20180630-3a866925-dirty/dronin_linux_20180630-3a866925-dirty "$out"
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
