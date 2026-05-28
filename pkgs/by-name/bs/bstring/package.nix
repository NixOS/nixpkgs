{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstring";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "msteinert";
    repo = "bstring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmBymVdfm1uKTg6quWIf0tdec98SuLHEA7q3q34XJtc=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Better String Library for C";
    homepage = "https://github.com/msteinert/bstring";
    changelog = "https://github.com/msteinert/bstring/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nulleric ];
  };
})
