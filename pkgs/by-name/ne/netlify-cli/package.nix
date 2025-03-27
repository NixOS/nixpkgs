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
  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-qz0OrVdnltNnGOX9mbLYWWMc+wBRtDC1jMHrL2Aa6vk=";
  };

  npmDepsHash = "sha256-mDVz/u6C1cL/67R/rZrEVVwIWEIjsDy4mA3mRLAFbM4=";

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
