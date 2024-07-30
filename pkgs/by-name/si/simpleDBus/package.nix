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

  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CPBdPnBeQ0c3VjSX0Op6nCHF3w0MdXGULbk1aavr+LM=";
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
