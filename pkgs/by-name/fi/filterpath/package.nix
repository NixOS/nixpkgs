{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "filterpath";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Sigmanificient";
    repo = "filterpath";
    rev = finalAttrs.version;
    hash = "sha256-GW8f3o7D5ddHQ8WZvds6rcsKPmlTSr/w4k2mU7oR6aM=";
  };

  makeFlags = [
    "CC=cc"
    "PREFIX=${placeholder "out"}/bin"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    echo "[`pwd`]" | ./filterpath | grep "`pwd`"

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/Sigmanificient/filterpath";
    description = "Retrieve a valid path from a messy piped line";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "filterpath";
    platforms = lib.platforms.linux;
  };
})
