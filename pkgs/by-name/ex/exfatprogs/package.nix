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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    tag = finalAttrs.version;
    hash = "sha256-twzHX8Uee0Uf8w1OsXWjecOl+Qs51jdJXK1sqdt6+4k=";
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
