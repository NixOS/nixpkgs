{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-octagram";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "lotem";
    repo = "librime-octagram";
    rev = "57d18b9f58e5284bd891d559f6bdd16cf60341e9";
    hash = "sha256-nQA8u0iqioLBM2rA57NPd7TOS49aHQl+mHKfu0sRwhY=";
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
