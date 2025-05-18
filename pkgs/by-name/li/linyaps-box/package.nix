{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  autoPatchelfHook,
  libcap,
  nlohmann_json,
  cli11,
  gtest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps-box";
  version = "2.0.0-rc.4";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = "linyaps-box";
    tag = finalAttrs.version;
    hash = "sha256-Egy7/c6spwP5RkO6Qn8YRLmQSC+7xlFISm/bp94wkO0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    libcap
    nlohmann_json
    cli11
    gtest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple OCI runtime mainly used by linyaps";
    homepage = "https://github.com/OpenAtom-Linyaps/linyaps-box";
    mainProgram = "ll-box";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
