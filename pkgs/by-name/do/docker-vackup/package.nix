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
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "BretFisher";
    repo = "docker-vackup";
    rev = "c57d5b8155bb65e080bf4c2d8841c8781e68f9ef";
    hash = "sha256-nalBD4RCOFyZrNjuuK5leqHfolBvIZ0YMtSTO744Zqs=";
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
