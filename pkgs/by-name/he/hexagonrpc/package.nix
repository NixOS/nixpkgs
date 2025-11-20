{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hexagonrpc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "hexagonrpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OC6wXBCIW4XznWG0zzxRK3BzWMVK2Jq/gTL36sJV1PE=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "";
    homepage = "https://github.com/linux-msm/hexagonrpc/tree/v0.4.0";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "hexagonrpc";
    platforms = lib.platforms.all;
  };
})
