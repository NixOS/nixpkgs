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
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-tXzfqelNwlG3iVIkhVDmXjDR6iKaUbVH5NQicDyHsDQ=";
  };

  cargoHash = "sha256-v0CJqq3Rz2dMyl8mA1hj1brnvbRc8rVo8UhOIQnNWFo=";

  cargoBuildFlags = [
    "-p"
    "silverbullet"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-1bzN7tsERaRUc9J3Yr23mj6kP/eZ9pW771ODUEW75lo=";

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
