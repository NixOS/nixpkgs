{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  check,
  pkg-config,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtsm";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "libtsm";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-xAMQOACyXfh3HhsX44mzGBsR6vqjv0uTRwc5ePfPPls=";
  };

  buildInputs = [
    libxkbcommon
    check
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
