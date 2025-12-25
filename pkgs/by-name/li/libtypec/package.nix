{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libusb1,
  systemd,
  libudev0-shim,
  gtk3, # utils
}:

stdenv.mkDerivation rec {
  pname = "libtypec";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "libtypec";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-XkT0bgBjoJTAFa9NLZdzbJSpchiXxKjeu88PeT/AlPY=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libusb1
    libudev0-shim
    systemd
    gtk3
  ];

  mesonFlags = [
    (lib.mesonBool "utils" true)
  ];

  meta = with lib; {
    homepage = "https://github.com/libtypec/libtypec";
    description = "generic diagnostic tool interface for usb-c ports";
    longDescription = "libtypec is aimed to provide a generic interface abstracting all platform complexity for user space to develop tools for efficient USB-C port management. The library can also enable development of diagnostic and debug tools to debug system issues around USB-C/USB PD topology.";
    platforms = platforms.linux;
    license = licenses.mit; # TODO: or gpl2
    maintainers = with maintainers; [ colemickens ];
  };
}
