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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cdundZSbWn8wXByYeXI4lQ3gWtBj3DkPQ37Py0bL3IY=";
  };

  pnpmDeps = fetchPnpmDeps {
    fetcherVersion = 3;
    inherit (finalAttrs) pname version src;
    hash = "sha256-0CS6BTjTj/TAnMNahTk4Vt/0/2eMxmCGUV9PwI8l4Ao=";
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

    rm -rf node_modules
    pnpm install --force --offline --production --ignore-scripts

    mkdir -p $out/lib/node_modules/skills/
    mkdir $out/bin
    cp -r dist bin node_modules package.json $out/lib/node_modules/skills

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
