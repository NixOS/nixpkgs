{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  pkg-config,
  enableUdev ?
    stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic && !stdenv.hostPlatform.isAndroid,
  udev,
  udevCheckHook,
  withExamples ? false,
  withStatic ? false,
  withDocs ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation rec {
  pname = "libusb";
  version = "1.0.29";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb";
    rev = "v${version}";
    sha256 = "sha256-m1w+uF8+2WCn72LvoaGUYa+R0PyXHtFFONQjdRfImYY=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocs [ "doc" ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ]
  ++ lib.optionals withDocs [ doxygen ];
  propagatedBuildInputs = lib.optional enableUdev udev;

  # Many dependents are dealing with hardware devices, exposing udev rules for them.
  # Checking these by propagated hook might improve discoverability
  propagatedNativeBuildInputs = lib.optional enableUdev udevCheckHook;

  dontDisableStatic = withStatic;

  # libusb-1.0.rc:11: fatal error: opening dependency file .deps/libusb-1.0.Tpo: No such file or directory
  dontAddDisableDepTrack = stdenv.hostPlatform.isWindows;

  configureFlags =
    lib.optional (!enableUdev) "--disable-udev" ++ lib.optional withExamples "--enable-examples-build";

  postBuild = lib.optionalString withDocs ''
    make -C doc
    mkdir -p "$doc/share/doc/libusb"
    cp -r doc/api-1.0/* "$doc/share/doc/libusb/"
  '';

  preFixup = lib.optionalString enableUdev ''
    sed 's,-ludev,-L${lib.getLib udev}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  postInstall = lib.optionalString withExamples ''
    mkdir -p $out/{bin,sbin,examples/bin}
    cp -r examples/.libs/* $out/examples/bin
    ln -s $out/examples/bin/fxload $out/sbin/fxload
  '';

  meta = with lib; {
    homepage = "https://libusb.info/";
    description = "Cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
    '';
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      prusnak
      logger
    ];
  };
}
