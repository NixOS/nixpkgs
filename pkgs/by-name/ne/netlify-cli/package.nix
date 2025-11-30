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
  version = "23.12.2";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-+dFIEULE2Hqz9/K6Ly0gsG10NFIzfj/E14a5g05E3uM=";
  };

  # Prevent postinstall script from running before package is built
  # See https://github.com/netlify/cli/blob/v23.9.2/scripts/postinstall.js#L70
  # This currently breaks completions: https://github.com/NixOS/nixpkgs/issues/455005
  postPatch = ''
    touch .git
  '';

  npmDepsHash = "sha256-GXtMDPJbkAJylN47D6tDfvsisb9gSxE9ZcMM8BNVy9g=";

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
