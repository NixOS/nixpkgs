{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "await";
  version = "0.999";

  src = fetchFromGitHub {
    owner = "slavaGanzin";
    repo = "await";
    rev = "v${version}";
    hash = "sha256-z178TKA0x6UnpBQaA8dig2FLeJKGxPndfvwtmylAD90=";
  };

  buildPhase = ''
    runHook preBuild
    $CC await.c -o await -l pthread
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 await -t $out/bin
    install -Dm444 LICENSE -t $out/share/licenses/await
    install -Dm444 README.md -t $out/share/doc/await

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small binary that runs a list of commands in parallel and awaits termination";
    homepage = "https://await-cli.app";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "await";
  };
}
