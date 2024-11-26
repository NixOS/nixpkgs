{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  autoreconfHook,
  libselinux,
  libuuid,
  pkg-config,
  lz4,
  lzo,
}:

stdenv.mkDerivation rec {
  pname = "f2fs-tools";
  version = "1.16.0";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot/f2fs-tools-v${version}.tar.gz";
    hash = "sha256-zNG1F//+BTBzlEc6qNVixyuCB6PMZD5Kf8pVK0ePYiA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libselinux
    libuuid
    lz4
    lzo
  ];

  patches = [
    ./f2fs-tools-cross-fix.patch

    (fetchpatch {
      name = "lfs64.patch";
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/patch/?id=b15b6cc56ac7764be17acbdbf96448f388992adc";
      hash = "sha256-9XrNf9MMMDGOsuP3DvUhm30Sa2xICDtXbUIvM/TP35o=";
    })
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ehmry
      jagajaga
    ];
  };
}
