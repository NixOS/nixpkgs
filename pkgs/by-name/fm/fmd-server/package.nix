{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  stdenv,
  versionCheckHook,
}:
buildGoModule (
  finalAttrs:
  let
    inherit (finalAttrs.finalPackage.passthru) ui;
  in
  {
    pname = "fmd-server";
    version = "0.17.0";
    src = fetchFromGitLab {
      owner = "fmd-foss";
      repo = "fmd-server";
      tag = "v${finalAttrs.version}";
      hash = "sha256-drZQj5tp0cHvrc+T1ESBHNNt0VoHhS9O93LIwjw2eCc=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (ui) pname src;
      pnpm = pnpm_11;
      sourceRoot = "${finalAttrs.src.name}/${ui.pnpmRoot}";
      fetcherVersion = 4;
      hash = "sha256-L6O1xsRw3ZwWg+83hC5n3a83RzSh9u0289gUHzfubJE=";
    };

    vendorHash = "sha256-fTteh+h4PqiISrqSjEK59jBog+tOu7Yzql8nYRK7q74=";

    preBuild = ''
      cp -r ${ui}/${ui.distRoot} web/
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgramArg = "version";

    doInstallCheck = true;
    passthru.updateScript = nix-update-script { };

    passthru.ui = stdenv.mkDerivation {
      inherit (finalAttrs) version src pnpmDeps;
      pname = "${finalAttrs.pname}-web-ui";

      pnpmRoot = "web";
      distRoot = "dist";

      nativeBuildInputs = [
        nodejs
        pnpmConfigHook
        pnpm_11
      ];

      buildPhase = ''
        runHook preBuild

        pushd web
        pnpm build
        popd

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"
        cp -r '${ui.pnpmRoot}/${ui.distRoot}' "$out"

        runHook postInstall
      '';
    };

    meta = {
      description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
      homepage = "https://fmd-foss.org/";
      downloadPage = "https://gitlab.com/fmd-foss/fmd-server";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        j0hax
        jthulhu
        kybe236
      ];
      teams = [ lib.teams.ngi ];
      mainProgram = "fmd-server";
    };
  }
)
