{
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "netlify-cli";
  version = "18.0.2";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-GykzaVJyiAH7L9afK+PdwkqImo80ldcx420pM8V4WBg=";
  };

  npmDepsHash = "sha256-n6JUInqI4ioMTebYcJXJ1ff8MjUW/+Y3b2lS7zhuSdI=";

  inherit nodejs;

  buildInputs = [ vips ];
  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.test = callPackage ./test.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Netlify command line tool";
    homepage = "https://github.com/netlify/cli";
    changelog = "https://github.com/netlify/cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roberth ];
    mainProgram = "netlify";
  };
}
