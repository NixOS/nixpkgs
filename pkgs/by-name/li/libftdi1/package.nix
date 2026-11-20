{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  cmake,
  pkg-config,
  libusb1,
  libconfuse,
  cppSupport ? true,
  boost,
  pythonSupport ? true,
  python3,
  swig,
  docSupport ? true,
  doxygen,
  graphviz,
}:

let
  inherit (lib) optionals optionalString;
  onOff = a: if a then "ON" else "OFF";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libftdi";
  version = "1.6.rc1";

  src = fetchgit {
    url = "git://developer.intra2net.com/libftdi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-StXZE82teeMV7wmWh9pp9PA+5/tOSjBIzqVRSaxHt4k=";
  };

  patches = [ ./swig-4.5-compat.patch ];

  strictDeps = true;

  doInstallCheck = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ optionals docSupport [
    doxygen
    graphviz
  ]
  ++ optionals pythonSupport [ swig ];

  buildInputs = [ libconfuse ] ++ optionals cppSupport [ boost ];

  cmakeFlags = [
    "-DFTDIPP=${onOff cppSupport}"
    "-DBUILD_TESTS=${onOff cppSupport}"
    "-DLINK_PYTHON_LIBRARY=${onOff pythonSupport}"
    "-DPYTHON_BINDINGS=${onOff pythonSupport}"
    "-DDOCUMENTATION=${onOff docSupport}"
  ]
  ++ lib.optionals pythonSupport [
    "-DPython3_EXECUTABLE=${python3.pythonOnBuildForHost.interpreter}"
    "-DPython3_LIBRARY=${python3}/lib/libpython${python3.pythonVersion}${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  propagatedBuildInputs = [ libusb1 ];

  postPatch = ''
    substituteInPlace packages/99-libftdi.rules \
      --replace-fail 'GROUP="plugdev"' 'GROUP="ftdi"'

    substituteInPlace packages/99-libftdi.rules \
      --replace-fail 'GROUP="ftdi"' 'GROUP="ftdi", TAG+="uaccess"'
  '';

  postInstall = ''
    install -Dm644 ../packages/99-libftdi.rules "$out/etc/udev/rules.d/60-libftdi.rules"
  ''
  + optionalString docSupport ''
    cp -r doc/man "$out/share/"
    cp -r doc/html "$out/share/doc/libftdi1/"
  '';

  preFixup = ''
    substituteInPlace $out/lib/pkgconfig/libftdi1.pc --replace-fail "libdir=$out/$out/lib" "libdir=$out/lib"
    substituteInPlace $out/lib/pkgconfig/libftdipp1.pc --replace-fail "libdir=$out/$out/lib" "libdir=$out/lib"
  '';

  meta = {
    description = "Library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = with lib.licenses; [
      # clarified in 92d657bcb543a9622947d984d4a8e725fb680e8c
      lgpl2Only # libftdi
      gpl2Only # ftdi_eeprom
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
})
