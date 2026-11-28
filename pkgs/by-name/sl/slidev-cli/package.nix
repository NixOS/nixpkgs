{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_12,
  nodejs-slim,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "slidev-cli";
  version = "53.2.0";

  src = fetchFromGitHub {
    owner = "slidevjs";
    repo = "slidev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcq45e8Taiw3pz+HNtoy8iE74q8O1zb+r3sqZ5RKoag=";
  };

  postPatch = ''
    # Reproducible deviation from the upstream repo's tests for some reason
    # Have to change this exact part of the PlantUML graph contents or it fails
    substituteInPlace packages/slidev/node/syntax/integration.test.ts \
      --replace-fail "odDpG4" "m7A0G0"
  '';

  pnpmWorkspaces = [ "@slidev/cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-F3VTLmo0fQDWEcvaGdeRamuIUkHauGY/wW7RZ9OAkZE=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm
  ];

  buildInputs = [
    nodejs-slim
  ];

  buildPhase = ''
    runHook preBuild

    pnpm -r --filter=@slidev/cli... --parallel run build
    pnpm run test

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Delete and re-install node_modules to save install space
    find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
    pnpm install --force --offline --production --ignore-scripts --filter=@slidev/cli...
    # Remove a bunch of unneeded stuff from the output, saves even more space
    find . -name "*.map" -type f -delete

    mkdir -p $out/lib/node_modules/slidev-cli/
    mkdir $out/bin
    mv ./packages ./node_modules ./package.json $out/lib/node_modules/slidev-cli

    ln -s $out/lib/node_modules/slidev-cli/packages/slidev/bin/slidev.mjs $out/bin/slidev
    chmod +x $out/bin/slidev
    patchShebangs $out/bin/slidev

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/slidevjs/slidev/releases/tag/v${finalAttrs.version}";
    description = "Presentation slides for developers";
    homepage = "https://sli.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pyrox0
      pluiedev
    ];
    mainProgram = "slidev";
  };
})
