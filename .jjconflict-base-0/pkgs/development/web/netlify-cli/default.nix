{
  callPackage,
  vips,
  pkg-config,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "netlify-cli";
  version = "17.37.1";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-34WvnbvLv2bB8CTlFKf351eQ5enYRhDqHoHRvJTBq4M=";
  };

  npmDepsHash = "sha256-zbr8TVCIKa/x5vzc3bR++qDcu0AuAgq1rfE69rytCWw=";

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
