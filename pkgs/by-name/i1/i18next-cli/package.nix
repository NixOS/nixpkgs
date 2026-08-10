{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "i18next-cli";
  version = "1.67.8";

  src = fetchFromGitHub {
    owner = "i18next";
    repo = "i18next-cli";
    tag = "v${version}";
    hash = "sha256-l3lm29c8lPkNc3d5HVXagyaft2ADne7NVcg33YVWq5A=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-isbHvMYeL9taBjTyHMp5Wdae1mClgqXsr7UJGbyBUqA=";

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
