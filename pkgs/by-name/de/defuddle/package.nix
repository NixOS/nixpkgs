{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "defuddle";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = version;
    hash = "sha256-H6/hZVe5nj6GNv00RMu1tKDRhCTvB7PX5gc70JWh9ik=";
  };

  npmDepsHash = "sha256-B5uX7lIfII9nlCHn6d3zchsokpZFOuP1fuRRLJb7g1M=";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Command line utility to extract clean html, markdown and metadata from web pages";
    homepage = "https://github.com/kepano/defuddle";
    license = lib.licenses.mit;
    mainProgram = "defuddle";
    maintainers = with lib.maintainers; [ surfaceflinger ];
  };
}
