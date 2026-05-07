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
  version = "23.15.0";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-y81VmYt5NDXNcipPY4DIWDICF3a0eETJVQRFRATi1Dk=";
  };

  # Prevent postinstall script from running before package is built
  # See https://github.com/netlify/cli/blob/v23.9.2/scripts/postinstall.js#L70
  # This currently breaks completions: https://github.com/NixOS/nixpkgs/issues/455005
  postPatch = ''
    touch .git
  '';

  npmDepsHash = "sha256-yKDLaNIofYLsoWvxaZUfY+LyVd/s4NGD+LEmd9Y7CAA=";

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
