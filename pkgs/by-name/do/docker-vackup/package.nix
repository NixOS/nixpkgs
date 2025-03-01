{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  docker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docker-vackup";
  version = "0-unstable-2024-11-01";

  src = fetchFromGitHub {
    owner = "BretFisher";
    repo = "docker-vackup";
    rev = "2a8a73136302af0bebeb7f210fc14be868ab2958";
    hash = "sha256-/iMQNnkRNTMiw+E6Wv/WatRB0DnapOVWqqszluUFed4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    substituteInPlace vackup --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 vackup "$out/bin/vackup"

    wrapProgram "$out/bin/vackup" \
      --suffix PATH : ${lib.makeBinPath [ docker ]}

    runHook postInstall
  '';

  meta = {
    description = "Shell script to backup and restore Docker volumes";
    homepage = "https://github.com/BretFisher/docker-vackup";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "vackup";
  };
})
