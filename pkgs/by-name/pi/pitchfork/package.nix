{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  rustPlatform,
  stdenv,
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
    version = "2.23.0";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "jdx";
      repo = "pitchfork";
      tag = "v${finalAttrs.version}";
      hash = "sha256-P3N4YquQPJ+xr/M6foK9r2EDKjOsslRVMU3aIsJr04U=";
    };

    cargoHash = "sha256-jNf0dTsZgS8CWBrGu+o1d11Nil9OgsLykxNkGxTd9aY=";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname src version;
      hash = finalAttrs.cargoHash;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 3;
      hash = "sha256-zh0JlHe6NDpsuDKsGq5Eto8Rx7gGLc7ayxV/NIhm4EQ=";
    };

    preBuild = ''
      mkdir -p ui/dist
      cp -r ${webui}/. ui/dist/
    '';

    doCheck = false;

    meta = {
      homepage = "https://pitchfork.jdx.dev";
      description = "Daemons with DX";
      changelog = "https://github.com/jdx/pitchfork/blob/${finalAttrs.src.tag}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "pitchfork";
      maintainers = with lib.maintainers; [ esteve ];
    };
  }
)
