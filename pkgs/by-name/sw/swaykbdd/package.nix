{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  json_c,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swaykbdd";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swaykbdd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FtXmn5Lf0PhL99xGl/SHWNaE6vAMOF2Ok4xVJT2Bf/s=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ json_c ];

  meta = {
    description = "Per-window keyboard layout for Sway";
    homepage = "https://github.com/artemsen/swaykbdd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    platforms = lib.platforms.linux;
    mainProgram = "swaykbdd";
  };
})
