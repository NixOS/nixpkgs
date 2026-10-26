{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10, # upstream uses pnpm 9 which is insecure. pnpm 11 breaks when fetching deps.
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  installShellFiles,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openspec";
  version = "1.14.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Fission-AI";
    repo = "OpenSpec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tdTX0nkDe/aNZgLckh6/B6BtoSb40w0Y5qzg+d1LjHU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-fKm4sBdTDeQfIiE0k301jtRbiuJrBE7YIEBu8RZxuXI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    makeWrapper
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/openspec

    substituteInPlace bin/openspec.js \
      --replace-fail '#!/usr/bin/env node' '#!${nodejs}/bin/node' \
      --replace-fail "../dist" "$out/lib/openspec/dist"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-native system for spec-driven development";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      sarahec
    ];
    platforms = lib.platforms.all;
    mainProgram = "openspec";
  };
})
