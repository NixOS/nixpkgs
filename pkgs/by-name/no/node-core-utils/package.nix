{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "node-core-utils";
  version = "5.12.2";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    rev = "v${version}";
    hash = "sha256-AuTcBAuLtsFFTjmteotSAv9VUFnAYs5FRoExRQ3een4=";
  };

  npmDepsHash = "sha256-ukkZNgQAhNm4SS3JtfsiTUdeCoKKMc0izSv04TZK/n8=";

  # Upstream doesn't provide any lock file so we provide our own:
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--omit=dev" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
    description = "CLI tools for Node.js Core collaborators";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
}
