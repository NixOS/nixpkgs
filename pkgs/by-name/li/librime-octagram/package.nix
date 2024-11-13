{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-octagram";
  version = "0-unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "lotem";
    repo = "librime-octagram";
    rev = "bd12863f45fbbd5c7db06d5ec8be8987b10253bf";
    hash = "sha256-77g72tee4ahNcu3hfW1Okqr9z8Y6WrPgUhw316O72Ng=";
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
