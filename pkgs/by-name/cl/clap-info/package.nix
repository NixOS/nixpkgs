{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clap-info";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-info";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-H2Nxx+p8uxm82qJbwfkKlAzyJkqC7c5tIexgghv38cY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp clap-info $out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to show information about a CLAP plugin on the command line";
    homepage = "https://github.com/free-audio/clap-info";
    changelog = "https://github.com/free-audio/clap-info/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bandithedoge ];
    mainProgram = "clap-info";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
