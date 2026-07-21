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
    sha256 = "1vhz84kxfyl0q7mkqn68nvzzly0a4xgzv76m6db0bk7xyczv1qr2";
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
