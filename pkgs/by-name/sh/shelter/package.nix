{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shelter";
  version = "0-unstable-2026-09-06";
  src = fetchFromGitHub {
    owner = "uwu";
    repo = "shelter";
    rev = "ee10d4ecb2fd62fb86ebfdbd37a4e28df9e72f11";
    hash = "sha256-Ew6RUhIS2gRuCNkbNCNtlmtYSGtjBR4h+UebuDVWhmk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  __structuredAttrs = true;
  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-d8GGz/2aCv2YV6CIxs1vkUfjYrhzsc8LyJX2sXgelig=";
    pnpm = pnpm_10;
    fetcherVersion = 4;
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@uwu/shelter-ui prepare
    pnpm --filter=shelter build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r packages/shelter/dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0.*)"
    ];
  };

  meta = {
    description = "New generation Discord client mod built to be essentially bulletproof";
    homepage = "https://shelter.uwu.network/";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ bandithedoge ];
  };
})
