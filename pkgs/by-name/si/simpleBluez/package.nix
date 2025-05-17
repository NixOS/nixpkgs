{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dbus,
  fmt_9,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "simpleBluez";

  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VaaDk+pLRUlVjGKFzi22QhYxk1b2bo6rX9TVeJsJdh8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/simplebluez";

  cmakeFlags = [ "-DLIBFMT_LOCAL_PATH=${fmt_9.src}" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = with lib; {
    description = "C++ abstraction layer for BlueZ over DBus";
    homepage = "https://github.com/OpenBluetoothToolbox/SimpleBLE";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aciceri ];
  };
})
