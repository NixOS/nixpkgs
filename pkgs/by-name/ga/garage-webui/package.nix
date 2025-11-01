{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  pnpm_9,
  nix-update-script,
}:
let
  pnpm = pnpm_9;
in
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
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs') pname version src;
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
