{
  lib,
  buildNpmPackage,
  zip,
  stalwart_1,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "webui";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "webui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lNyU74O807vdQ0oNYU1PdqdxzNZAl/dU9j6buFCo7C4=";
  };

  npmDepsHash = "sha256-j9HR3oeJUJBlnAOS4e1pCN6ADmmJHonstrO2y09RyEc=";
  __structuredAttrs = true;

  env = {
    # https://github.com/stalwartlabs/webui/tree/main#environment-variables
    # https://github.com/stalwartlabs/webui/blob/main/.env.development
    VITE_API_BASE_URL = "";
  };

  nativeBuildInputs = [ zip ];
  preBuild = ''
    rm .env.development
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cd dist
    zip -r $out/webui.zip *
    cd ..
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Stalwart WebUI";
    longDescription = ''
      Stalwart WebUI is schema-driven single-page application for administering Stalwart.

      After authentication the panel fetches a JSON schema from the server and dynamically
      generates all forms, lists, navigation, and layouts from that schema. Nothing is hardcoded.
    '';
    homepage = "https://github.com/stalwartlabs/webui";
    changelog = "https://github.com/stalwartlabs/webui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.agpl3Only
      {
        fullName = "Stalwart Enterprise License 2.0 (SELv2) Agreement";
        url = "https://github.com/stalwartlabs/webui/blob/main/LICENSES/LicenseRef-SEL.txt";
        free = false;
        redistributable = false;
      }
    ];
    inherit (stalwart_1.meta) maintainers;
  };
})
