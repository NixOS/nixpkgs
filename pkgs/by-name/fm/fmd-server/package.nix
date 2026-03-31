{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpm,
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
    version = "0.14.1";
    src = fetchFromGitLab {
      owner = "fmd-foss";
      repo = "fmd-server";
      tag = "v${finalAttrs.version}";
      hash = "sha256-UmiYtriLC9qztv7nW+1tFpYv9I0NAOsApAJWP72OINg=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (ui) pname;
      inherit pnpm;
      sourceRoot = "${finalAttrs.src.name}/${ui.pnpmRoot}";
      fetcherVersion = 3;
      hash = "sha256-fgqNaFQ4+uJxXzDJJq+D0+EFaLaYR+WUzi5kGq5ezjs=";
    };

    vendorHash = "sha256-cFIg9mOSQbrYHW4kg4aTeTaF+gy1jNpAlg8qepb81Jc=";

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
        pnpm
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

    postUnpack = ''
      cp -r ${ui}/${ui.distRoot} /build/source/web/
    '';

    meta = {
      description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
      homepage = "https://fmd-foss.org/";
      downloadPage = "https://gitlab.com/fmd-foss/fmd-server";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        j0hax
        jthulhu
      ];
      teams = [ lib.teams.ngi ];
      mainProgram = "fmd-server";
    };
  }
)
