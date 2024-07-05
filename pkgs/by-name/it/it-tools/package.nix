{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "it-tools";
  version = "2024.5.13-a0bc346";

  src = fetchFromGitHub {
    owner = "CorentinTh";
    repo = "it-tools";
    rev = "v${version}";
    hash = "sha256-hU+iPefnEt9MCipETAzaeguxi7aU9iyjwJdeddILJzU=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-hQwfJ0zLHyrvwbYa9hmQg0VWR1WwrZyR+hCmv+tHP3w=";
  };
  nativeBuildInputs = [
    pnpm.configHook
    nodejs
  ];
  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.n8n;
  };

  meta = with lib; {
    description = "Collection of handy online tools for developers, with great UX";
    homepage = "https://github.com/CorentinTh/it-tools";
    changelog = "https://github.com/CorentinTh/it-tools/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ericthemagician ];
    mainProgram = "it-tools";
    platforms = platforms.all;
  };
}
