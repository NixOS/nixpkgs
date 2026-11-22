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
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    tag = finalAttrs.version;
    hash = "sha256-HehCL80K3D8hUOk+l2SAEbh3NzVChD1eA1vXxQcO3q0=";
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
