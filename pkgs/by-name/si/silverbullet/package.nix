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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-aEqmvxtWzvXM8Cv8YrHK9o0G2jlbeqqahAveKr6M+Ps=";
  };

  cargoHash = "sha256-t2RDrdZsCMReDGUUu3r59OAosZNY3TMlvjo/uM2xL8g=";

  cargoBuildFlags = [
    "-p"
    "silverbullet"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-EseKAqUJbpIAfJhG1hNlvLgMie/jsXbbVqwea8bEuJQ=";

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
