{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs_20,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  installShellFiles,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openspec";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Fission-AI";
    repo = "OpenSpec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DIMMOEVQ2FQj48WAF4S1IhxX5ChrFZll51CZ3bZNGHE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-9s2kdvd7svK4hofnD66HkDc86WTQeayfF5y7L2dmjNg=";
  };

  nativeBuildInputs = [
    nodejs_20
    pnpmConfigHook
    pnpm_9
    makeWrapper
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/openspec

    substituteInPlace bin/openspec.js \
      --replace '#!/usr/bin/env node' '#!${nodejs_20}/bin/node' \
      --replace "../dist" "$out/lib/openspec/dist"
    install -Dm755 bin/openspec.js $out/bin/openspec

    cp -r dist $out/lib/openspec/
    cp -r schemas $out/lib/openspec/
    cp package.json $out/lib/openspec/
    cp -r node_modules $out/lib/openspec/

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd openspec \
      --bash <($out/bin/openspec completion generate bash) \
      --fish <($out/bin/openspec completion generate fish) \
      --zsh <($out/bin/openspec completion generate zsh)
  '';

  meta = {
    description = "AI-native system for spec-driven development";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ superherointj ];
    platforms = lib.platforms.all;
    mainProgram = "openspec";
  };
})
