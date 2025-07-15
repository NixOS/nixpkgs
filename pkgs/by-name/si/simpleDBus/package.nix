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
  pname = "simpleDBus";

  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eEbptFy5tlIHuBu+HbPxsgdb9CVNXq8r2KKP0E8SIuE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/simpledbus";

  cmakeFlags = [ "-DLIBFMT_LOCAL_PATH=${fmt_9.src}" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = with lib; {
    description = "C++ wrapper for libdbus-1";
    homepage = "https://github.com/OpenBluetoothToolbox/SimpleBLE";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aciceri ];
  };
})
