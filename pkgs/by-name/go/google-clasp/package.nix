{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "clasp";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "clasp";
    tag = "v${version}";
    hash = "sha256-6HHkGcWzzrfIjQUPycSkF4pM/vrOo9rvWUnhHrA4LJ8=";
  };

  npmDepsHash = "sha256-zQt+diejFiG1oEkXxN5/X9rh33wHenk+iWeHsack/kY=";

  # `npm run build` tries installing clasp globally
  npmBuildScript = [ "compile" ];

  meta = {
    description = "Develop Apps Script Projects locally";
    mainProgram = "clasp";
    homepage = "https://github.com/google/clasp#readme";
    changelog = "https://github.com/google/clasp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
