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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "DavidAnson";
    repo = "markdownlint-cli2";
    tag = "v${version}";
    hash = "sha256-wZfLTk7F9HZaRFvYEo5rT+k/ivNk0fU+p844LMO06ek=";
  };

  npmDepsHash = "sha256-tWvweCpzopItgfhpiBHUcpBvrJYCiq588WXzF9hvFfs=";

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
