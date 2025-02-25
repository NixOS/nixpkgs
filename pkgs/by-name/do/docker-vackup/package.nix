{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp vackup $out/bin/vackup
    chmod +x $out/bin/vackup

    wrapProgram $out/bin/vackup \
      --prefix PATH : ${lib.makeBinPath [ docker ]}

    runHook postInstall
  '';

  meta = {
    description = "Shell script to backup and restore Docker volumes";
    homepage = "https://github.com/BretFisher/docker-vackup";
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "vackup";
  };
})
