{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  npm-lockfile-fix,
}:
buildNpmPackage (finalAttrs: {
  pname = "actions-languageserver";
  version = "0.3.34";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "languageservices";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-VcDzj5+gGUNbcPu/yAdRbHGGJ3kn+keEWjk644g0kuY=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
      substituteInPlace $out/package-lock.json $out/languageservice/package.json \
        --replace-fail '"rest-api-description": "github:github/rest-api-description"' '"rest-api-description": "^1.0.0"'
    '';
  };

  nodejs = nodejs_22;
  npmWorkspace = "languageserver";

  npmDepsHash = "sha256-eem/Iwp3PhzgLIMko4EdsJOzHiAfWtOJ0HSdojf3DFk=";

  preBuild = ''
    patchShebangs .
    npm run build --workspace=expressions
    npm run build --workspace=workflow-parser
    npm run build --workspace=languageservice
  '';

  # Copy workspace packages to output to fix symlinks
  postInstall = ''
    cp -r expressions workflow-parser languageservice languageserver $out/lib/node_modules/actions-languageservices/
  '';

  meta = {
    homepage = "https://github.com/actions/languageservices";
    description = "Language server for GitHub Actions";
    mainProgram = "actions-languageserver";
    maintainers = with lib.maintainers; [ keirlawson ];
    license = with lib.licenses; [ mit ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
