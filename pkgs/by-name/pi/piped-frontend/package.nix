{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "piped";
  version = "0-unstable-2024-07-09";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped";
    rev = "174a4cc86cc5790c47443fc4f35d41360bef99b0";
    hash = "sha256-HKzwnhMBRFz4Ed7m+bg5c3g0ZtHvoquo6vvXLAnlhWU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-zMrftk8gd0t+2bQMEgEHucXkROUfUpKb8Nssj5/C56s=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = with lib; {
    description = "An alternative privacy-friendly YouTube frontend which is efficient by design";
    homepage = "https://github.com/TeamPiped/Piped/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "piped";
    platforms = platforms.all;
  };
}
