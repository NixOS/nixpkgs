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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-tcn0NrABLnX22OWJ3PzYJ5xbTLyNH5p6JtJ6CujkpQQ=";
  };

  cargoHash = "sha256-M/bX9oj76kmXGkCzvBJZMeI7/4UJ+yvz84KrysyPOLA=";

  cargoBuildFlags = [
    "-p"
    "silverbullet"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-We3K4jZGcC5Q1WBgEOKDKhn8M83srNLP3C36WCOX5Qs=";

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
