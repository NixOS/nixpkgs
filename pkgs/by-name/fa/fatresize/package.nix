{
  lib,
  stdenv,
  fetchFromGitHub,
  parted,
  util-linux,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {

  version = "1.1.0";
  pname = "fatresize";

  src = fetchFromGitHub {
    owner = "ya-mouse";
    repo = "fatresize";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IuOwP/P9zAVWM9Wc/V8nCnj6/7bIWDzrwYB61ydBH+4=";
  };

  buildInputs = [
    parted
    util-linux
  ];
  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    parted
    util-linux
  ];

  meta = {
    description = "FAT16/FAT32 non-destructive resizer";
    homepage = "https://github.com/ya-mouse/fatresize";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    mainProgram = "fatresize";
  };
})
