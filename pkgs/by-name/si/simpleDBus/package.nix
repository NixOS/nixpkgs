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

  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-suVaiFE60g2OlIF4DLGoHKr7ehUtThLcB/GoVCOfxJg=";
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
