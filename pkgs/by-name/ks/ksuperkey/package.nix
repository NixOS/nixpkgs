{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxtst,
  pkg-config,
  xorgproto,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksuperkey";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "hanschen";
    repo = "ksuperkey";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CmEeb4zpCQH23Qg2FGBhJrW3DQ6cf3nRVg5GZ8pwb7c=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    libxtst
    xorgproto
    libxi
  ];

  meta = {
    description = "Tool to be able to bind the super key as a key rather than a modifier";
    homepage = "https://github.com/hanschen/ksuperkey";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ksuperkey";
  };
})
