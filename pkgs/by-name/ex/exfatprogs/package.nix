{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  file,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exfatprogs";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    tag = finalAttrs.version;
    hash = "sha256-y7uc3Ifgf4JhTcHxIR72QMpycbI2d7lYlTZixb1fd4g=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

  buildInputs = [
    util-linux
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ yuannan ];
    platforms = lib.platforms.linux;
  };
})
