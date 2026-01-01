{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
=======
  nix-update-script,
}:
let
  pnpm = pnpm_9;
in
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
buildGoModule (finalAttrs: {
  pname = "garage-webui";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "khairul169";
    repo = "garage-webui";
    tag = finalAttrs.version;
    hash = "sha256-bqUAhZBSQkWZ1QsgPslEUDwt8NOg25Os0NGlPoyjPL4=";
  };

  frontend = stdenv.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
<<<<<<< HEAD
      pnpmConfigHook
      pnpm_9
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs') pname version src;
      pnpm = pnpm_9;
=======
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs') pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fetcherVersion = 2;
      hash = "sha256-8eQhR/fuDFNL8W529Ev7piCaseVaFahgZJQk3AJA3ng=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out/
      runHook postInstall
    '';
  });

  preBuild = ''
    cp -r ${finalAttrs.frontend} ./ui/dist
  '';

  modRoot = "./backend";
  tags = [ "prod" ];
  env.CGO_ENABLED = 0;
  vendorHash = "sha256-7z6r6w/SbBlYYHMxm11xFl/QEYZc2KebnOJZRgYRUYk=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple admin web UI for Garage";
    homepage = "https://github.com/khairul169/garage-webui";
    changelog = "https://github.com/khairul169/garage-webui/releases/tag/${finalAttrs.version}";
    mainProgram = "garage-webui";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ griffi-gh ];
  };
})
