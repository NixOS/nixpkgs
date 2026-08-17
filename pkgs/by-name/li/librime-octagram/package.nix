{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-octagram";
  version = "0-unstable-2024-11-18";

  src = fetchFromGitHub {
    owner = "lotem";
    repo = "librime-octagram";
    rev = "dfcc15115788c828d9dd7b4bff68067d3ce2ffb8";
    hash = "sha256-dgUsH10V87mEcX/k3N118qbKo3fKDFcS8inhS6p5bJc=";
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
