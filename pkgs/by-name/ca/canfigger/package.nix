{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "canfigger";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "andy5995";
    repo = "canfigger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vqNfakpouoQGKFCyNsn4Cney0UXVYBMCJhwEhaIGPrI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Lightweight library designed to parse configuration files";
    homepage = "https://github.com/andy5995/canfigger";
    changelog = "https://github.com/andy5995/canfigger/blob/${finalAttrs.src.rev}/ChangeLog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "canfigger";
    platforms = lib.platforms.all;
  };
})
