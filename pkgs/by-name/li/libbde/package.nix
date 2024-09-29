{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  ncurses,
  python3,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbde";
  version = "0-unstable-20221031";

  src = fetchFromGitHub {
    owner = "libyal";
    repo = "libbde";
    rev = "a7bf86d0907b84dfb551fdd3f6f548bd687fdcac";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    fuse
    ncurses
    python3
  ];

  configureFlags = [ "--enable-python" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      eliasp
      bot-wxt1221
    ];
    platforms = lib.platforms.all;
  };
})
