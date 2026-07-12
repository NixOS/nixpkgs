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
  version = "0-unstable-2026-06-10";
  src = fetchFromGitHub {
    owner = "uwu";
    repo = "shelter";
    rev = "6217da059488a0d367b661c20ae5fa52e3cbbe9c";
    hash = "sha256-aF13I8zLF1mluhnE8OJSwnatCcqujP1UuQDlbXEUhPM=";
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
