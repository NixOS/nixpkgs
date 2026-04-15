{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  markdownlint-cli2,
  nix-update-script,
  runCommand,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli2";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "DavidAnson";
    repo = "markdownlint-cli2";
    tag = "v${version}";
    hash = "sha256-ftfj7IZQxSaEwQ2Rry2iLD2hqEd5UDHIziW/u4qEIEk=";
  };

  npmDepsHash = "sha256-jtONdZPfpnOOiDH8UmFFWDgwcOYvTnBo8FkY8Ec+TYU=";

  postPatch = ''
    rm -f .npmrc
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru = {
    tests = {
      smoke = runCommand "${pname}-test" { nativeBuildInputs = [ markdownlint-cli2 ]; } ''
        markdownlint-cli2 ${markdownlint-cli2}/lib/node_modules/markdownlint-cli2/CHANGELOG.md > $out
      '';
    };
    updateScript = nix-update-script {
      extraArgs = [ "--generate-lockfile" ];
    };
  };

  meta = {
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/v${version}/CHANGELOG.md";
    description = "Fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anthonyroussel
      natsukium
    ];
    mainProgram = "markdownlint-cli2";
  };
}
