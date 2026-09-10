{
  lib,
  buildNpmPackage,
  fetchFromGitLab,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "ryuldn-web";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitLab {
    domain = "git.ryujinx.app";
    owner = "Ryubing";
    repo = "ldnweb";
    rev = "af8fd6a09b7a4edc34a6bab803e980b7c28093a5";
    hash = "sha256-KNAeNoj0R6D7kWYvzyRs5vOfDrIAJPlYWjLJEJXwTEE=";
  };

  npmDepsHash = "sha256-fqvUE5/M2VyIL5CyDEuUGye27e9fJJImMYL1wwZNFPg=";

  postPatch = ''
    substituteInPlace src/titleIdManager.ts \
      --replace-fail "this.filePath = \`\''${dataDirectory}/ryuldn/otherTitleIds.txt\`;" \
                     "this.filePath = \`\''${dataDirectory}/otherTitleIds.txt\`;"
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    cp -r package.json package-lock.json node_modules public $out

    makeWrapper '${nodejs}/bin/node' "$out/bin/ryujinx-ldn-website" --add-flags "$out/index.js"

    runHook postInstall
  '';

  meta = {
    homepage = "https://ldn.ryujinx.app";
    description = "Website which connects to a RyuLDN server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.unix;
    mainProgram = "ryujinx-ldn-website";
  };
})
