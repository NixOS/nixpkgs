{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "clasp";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "clasp";
    tag = "v${version}";
    hash = "sha256-Wt9caSgYNSx6yVUm3eg86GNdrheqHM5IYY8QohclHkQ=";
  };

  npmDepsHash = "sha256-iRC2iLNe/4ZP2liUDjIgyMNtlmjcXAGdSmhx3qFBjsA=";

  # `npm run build` tries installing clasp globally
  npmBuildScript = [ "compile" ];
  # Remove dangling symlink of a dependency
  postInstall = ''
    rm $out/lib/node_modules/@google/clasp/node_modules/.bin/sshpk-{verify,sign,conv}
  '';

  meta = {
    description = "Develop Apps Script Projects locally";
    mainProgram = "clasp";
    homepage = "https://github.com/google/clasp#readme";
    changelog = "https://github.com/google/clasp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
