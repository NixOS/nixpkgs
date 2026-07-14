{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  freetype,
  harfbuzz,
  fribidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libraqm";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "HOST-Oman";
    repo = "libraqm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6STgs9//BQRu1TTxf+L6+Jj0Z7rkaBFodXzQVRyybE4=";
  };

  buildInputs = [
    freetype
    harfbuzz
    fribidi
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  doCheck = true;

  meta = {
    description = "Library for complex text layout";
    homepage = "https://github.com/HOST-Oman/libraqm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
})
