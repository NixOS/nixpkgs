{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpmConfigHook,
  pnpm_9,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shelter";
  version = "0-unstable-2026-04-15";
  src = fetchFromGitHub {
    owner = "uwu";
    repo = "shelter";
    rev = "62c630bed8d118c7061d45c583121703c60a8448";
    hash = "sha256-pfA7D3b5hAca82hXkWv+Ysxy/pdHy4QaF1btiXM2YM4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  __structuredAttrs = true;
  strictDeps = true;

  pnpmWorkspaces = [
    "shelter"
    "@uwu/shelter-ui"
    "@uwu/shelter-storage"
  ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-4ZKAMtbXLg/ZWUPxYRlBSyMOP5QQN3Cmcgl+EIOsFoI=";
    pnpm = pnpm_9;
    fetcherVersion = 3;
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
