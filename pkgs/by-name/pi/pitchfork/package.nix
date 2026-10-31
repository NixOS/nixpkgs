{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    webui = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-webui";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/ui";
      pnpmDeps = finalAttrs.pnpmDeps;

      nativeBuildInputs = [
        nodejs
        pnpm
        pnpmConfigHook
      ];

      buildPhase = ''
        runHook preBuild

        pnpm build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r dist/. $out/

        runHook postInstall
      '';
    };
  in
  {
    pname = "pitchfork";
    version = "2.32.2";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "jdx";
      repo = "pitchfork";
      tag = "v${finalAttrs.version}";
      hash = "sha256-uWyhsGCr3vSdy8EwLj0Orb8br+pQEH19r1+CbvVTrQw=";
    };

    cargoHash = "sha256-0UBgpmDFUouT9vtw0G/StZBgICCQiP5jfEUqtac5kM8=";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname src version;
      hash = finalAttrs.cargoHash;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 3;
      hash = "sha256-/XbMChPNLO9aHly6PATVRpaMTpvQz01fNQbG7vsraMo=";
    };

    preBuild = ''
      mkdir -p ui/dist
      cp -r ${webui}/. ui/dist/
    '';

    doCheck = false;

    doInstallCheck = true;
    nativeInstallCheckInputs = [ versionCheckHook ];

    passthru.updateScript = nix-update-script { };

    meta = {
      homepage = "https://pitchfork.jdx.dev";
      description = "Daemons with DX";
      changelog = "https://github.com/jdx/pitchfork/blob/${finalAttrs.src.tag}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "pitchfork";
      maintainers = with lib.maintainers; [
        esteve
        anish
      ];
    };
  }
)
