{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "i18next-cli";
  version = "1.80.5";

  src = fetchFromGitHub {
    owner = "i18next";
    repo = "i18next-cli";
    tag = "v${version}";
    hash = "sha256-6Drhi0b3Xynx0DEm3wc7oTg9e6gBMRmUQhBK54uUJJg=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-vVzwK+muVtgfvE5P6b/G0N/bvvAis86EiU8fNnmkU2A=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "A unified, high-performance i18next CLI";
    changelog = "https://github.com/i18next/i18next-cli/blob/v${version}/CHANGELOG.md";
    homepage = "https://www.locize.com/blog/i18next-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbek ];
    mainProgram = "i18next-cli";
  };
}
