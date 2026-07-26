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
  pname = "simpledbus";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I6uZm3CSkOS2is2KZ6DRjEsryLms6k5UtwtZUq8Tbn0=";
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

  meta = {
    description = "C++ wrapper for libdbus-1";
    homepage = "https://github.com/OpenBluetoothToolbox/SimpleBLE";
    # SimpleBLE (which SimpleDBus is part of) is under the Business Source License 1.1 (BUSL-1.1)
    # since version 0.9.0
    license = lib.licenses.bsl11;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
