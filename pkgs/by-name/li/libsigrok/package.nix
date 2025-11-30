{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  libzip,
  glib,
  libusb1,
  libftdi1,
  check,
  libserialport,
  doxygen,
  glibmm,
  python3,
  hidapi,
  libieee1284,
  bluez,
  sigrok-firmware-fx2lafw,
}:

stdenv.mkDerivation {
  pname = "libsigrok";
  version = "0.5.2-unstable-2024-10-20";

  src = fetchgit {
    url = "git://sigrok.org/libsigrok";
    rev = "f06f788118191d19fdbbb37046d3bd5cec91adb1";
    hash = "sha256-8aco5tymkCJ6ya1hyp2ODrz+dlXvZmcYoo4o9YC6D6o=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
    python3
  ];
  buildInputs = [
    libzip
    glib
    libusb1
    libftdi1
    check
    libserialport
    glibmm
    hidapi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libieee1284
    bluez
  ];

  strictDeps = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp contrib/*.rules $out/etc/udev/rules.d

    mkdir -p "$out/share/sigrok-firmware/"
    cp ${sigrok-firmware-fx2lafw}/share/sigrok-firmware/* "$out/share/sigrok-firmware/"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # assert that c++ bindings are included
    # note that this is only true for modern (>0.5) versions; the 0.3 series does not have these
    [[ -f $out/include/libsigrokcxx/libsigrokcxx.hpp ]] \
      || { echo 'C++ bindings were not generated; check configure output'; false; }

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      bjornfor
      vifino
    ];
  };
}
