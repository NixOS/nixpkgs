{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  replaceVars,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "silverbullet";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-sNNAxCxWKclCAhtQpoFixyLRf5NMliJkgHovZ469WHE=";
  };

  cargoHash = "sha256-QTOVXtFlmlxjKSOV2VH8TLZ8nW1hLoGxMxjo9VNOc3k=";

  cargoBuildFlags = [
    "-p"
    "silverbullet"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-GSiHrktBqvYNAiARUjaMLLcrobMewjO9PLFX3ArxIf8=";

    patches = [
      (replaceVars ./override-version.patch { inherit (finalAttrs) version; })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r client_bundle version.json $out/

      runHook postInstall
    '';
  };

  preBuild = ''
    cp -r ${finalAttrs.frontend}/client_bundle .
    cp ${finalAttrs.frontend}/version.json .
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/docs/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aorith
      CnTeng
    ];
    mainProgram = "silverbullet";
  };
})
