{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-octagram";
  version = "0-unstable-2026-07-11";

  src = fetchFromGitHub {
    owner = "lotem";
    repo = "librime-octagram";
    rev = "c030e30e4df01a806841b64a438b55ec7b617b1f";
    hash = "sha256-kjUsG9Qm29nBYl/G/7FvHKirOq298scKFmaXtZfrcss=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --archive --verbose * $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "RIME essay grammar plugin";
    homepage = "https://github.com/lotem/librime-octagram";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ azuwis ];
  };
}
