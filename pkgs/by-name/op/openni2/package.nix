{
  stdenv,
  lib,
  fetchFromGitHub,
  libusb1,
  pkg-config,
  freeglut,
  libGLU,
  libx11,
  libjpeg_turbo,
  openjdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openni2";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "structureio";
    repo = "OpenNI2";
    rev = "v${finalAttrs.version}-debian";
    sha256 = "sha256-5ZisoZ5jvaGAmDnMvMOlgGYL+mI9pO7k+5aPgu/31lU=";
  };

  buildInputs = [
    libusb1
    freeglut
    libGLU
    libx11
    libjpeg_turbo
    openjdk
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  patches = [
    ./patches/Change-path-of-config-files-to-etc-openni2.patch
    ./patches/fix-format-overflow-for-GCC7.patch
    ./patches/Fix-GCC6-compilation.patch
    ./patches/Initialize-variable-for-gcc7.patch
  ];

  postInstall = ''
    # directories creation
    mkdir -p "$out/"{bin,include/openni2/{Driver,Linux-Arm,Linux-x86}}
    mkdir -p "$out/lib/"{OpenNI2/Drivers,pkgconfig}
    mkdir -p "$out/lib/udev/rules.d" # usb rules (udev rules)
    mkdir -p "$out/etc/openni2/Drivers"  # config

    # binaries and libraries
    install    -m755 Bin/x64-Release/NiViewer             "$out/bin/NiViewer2"
    install -D -m755 Bin/x64-Release/ClosestPointViewer   "$out/bin"
    install -D -m755 Bin/x64-Release/EventBasedRead       "$out/bin"
    install -D -m755 Bin/x64-Release/Multi*               "$out/bin"
    install -D -m755 Bin/x64-Release/MWClosestPointApp    "$out/bin"
    install -D -m755 Bin/x64-Release/PS*                  "$out/bin"
    install -D -m755 Bin/x64-Release/Simple*              "$out/bin"
    install -D -m755 Bin/x64-Release/*.so                 "$out/lib"
    install -D -m755 Bin/x64-Release/OpenNI2/Drivers/*.so "$out/lib/OpenNI2/Drivers"

    # includes
    install -D -m644 Include/*.h         "$out/include/openni2"
    install -D -m644 Include/Driver/*    "$out/include/openni2/Driver"
    install -D -m644 Include/Linux-Arm/* "$out/include/openni2/Linux-Arm"
    install -D -m644 Include/Linux-x86/* "$out/include/openni2/Linux-x86"

    # udev rules
    install -m644 Packaging/Linux/primesense-usb.rules "$out/lib/udev/rules.d/60-openni2-usb.rules"

    # config
    install -D -m644 Config/*.ini             "$out/etc/openni2"
    install -D -m644 Config/OpenNI2/Drivers/* "$out/etc/openni2/Drivers"

    cp ${./libopenni2.pc} $out/lib/pkgconfig/libopenni2.pc

    substituteInPlace $out/lib/pkgconfig/libopenni2.pc \
      --replace "@PREFIX@" "$out" \
      --replace "@VERSION@" "$version"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Drivers and libraries for the PrimeSense compatible depth sensors";
    homepage = "http://structure.io/openni";
    license = with lib.licenses; [
      asl20
    ];
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
