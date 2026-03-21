{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchPnpmDeps,
  nodejs_22,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.14.0";
  nodejs = nodejs_22;
in
buildGoModule (finalAttrs: {
  pname = "fmd-server";
  inherit version;

  src = fetchFromGitLab {
    owner = "fmd-foss";
    repo = "fmd-server";
    tag = "v${version}";
    hash = "sha256-6dqLJDVQfwwNW40Wsu0Sb2kqtDLLJxQeSUcnFasLyN0=";
  };

  webui = stdenv.mkDerivation {
    pname = "fmd-server-webui";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      sourceRoot = "${finalAttrs.src.name}/web";
      hash = "sha256-8emvxvsP60RxV7F7dBIyexKW51u+sPl2+NO/tfH+OLc=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out
      runHook postInstall
    '';
  };

  vendorHash = "sha256-cFIg9mOSQbrYHW4kg4aTeTaF+gy1jNpAlg8qepb81Jc=";

  preBuild = ''
    mkdir -p web/dist/
    cp -r ${finalAttrs.webui}/* web/dist/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
    homepage = "https://fmd-foss.org/";
    downloadPage = "https://gitlab.com/fmd-foss/fmd-server";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      j0hax
      shellhazard
    ];
    teams = [ lib.teams.ngi ];
    mainProgram = "fmd-server";
  };
})
