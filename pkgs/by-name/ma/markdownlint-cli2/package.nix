{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:

buildNpmPackage (finalAttrs: {
  pname = "markdownlint-cli2";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "DavidAnson";
    repo = "markdownlint-cli2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nWKkQdzwm+jLoZYs25USsdbRwXj++aS1tif2ro4FsBI=";
  };

  npmDepsHash = "sha256-cUwSR+B1MA6wciAemCxevT1VrtSEGzPUpBKzZzMul2E=";

  postPatch = ''
    rm -f .npmrc
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru = {
    tests = {
      smoke = runCommand "markdownlint-cli2-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
        markdownlint-cli2 ${finalAttrs.finalPackage}/lib/node_modules/markdownlint-cli2/CHANGELOG.md > $out
      '';
    };
    updateScript = nix-update-script {
      extraArgs = [ "--generate-lockfile" ];
    };
  };

  meta = {
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anthonyroussel
      natsukium
    ];
    mainProgram = "markdownlint-cli2";
  };
})
