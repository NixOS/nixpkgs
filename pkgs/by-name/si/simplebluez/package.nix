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
  pname = "simplebluez";

  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "simpleble";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GNLD62w5zTfW7CaknaZmU0jBro92HFw3gA29KJqOHGA=";
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

  meta = {
    description = "C++ abstraction layer for BlueZ over DBus";
    homepage = "https://github.com/simpleble/simpleble";
    # SimpleBLE (which SimpleBluez is part of) is under the Business Source License 1.1 (BUSL-1.1)
    # since version 0.9.0
    license = lib.licenses.bsl11;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
