{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  nodejs,
  pnpmConfigHook,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "skills";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H2ZUOjYbG2I2OBV4J8dil84cAhSh+j9ovJFbT88JVEo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-pwPJ4CRHEtCXpt5b6g/7EbDsUc2KCjOtpiVED0tqoMk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    node_modules/.bin/obuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/skills/
    mkdir $out/bin
    cp -r dist bin package.json $out/lib/node_modules/skills

    ln -s $out/lib/node_modules/skills/bin/cli.mjs $out/bin/skills
    chmod +x $out/bin/skills
    patchShebangs $out/bin/skills

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://github.com/vercel-labs/skills/releases/tag/v${finalAttrs.version}";
    description = "The open agent skills tool";
    homepage = "https://github.com/vercel-labs/skills";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "skills";
  };
})
