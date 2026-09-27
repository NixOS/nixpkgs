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
  version = "0-unstable-2026-09-16";
  src = fetchFromGitHub {
    owner = "uwu";
    repo = "shelter";
    rev = "0397ffe539fce088f8cab25cc086055d4a5feb71";
    hash = "sha256-Qagye5ksJyvoOIpoozfWmHTO8Or2F7KWOyXQgbK2vVY=";
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
