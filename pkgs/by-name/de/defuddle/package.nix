{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "defuddle";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = version;
    hash = "sha256-w1V2xdaE8Htl6NeDyfKLFHOt3UEUuI4eBPW433qD1WI=";
  };

  npmDepsHash = "sha256-D+Gn9Dcc+YNeRonnKjEcp3BzpxIdwy7J4lJvxefJSvs=";

  # jsdom is both a peerDependency and devDependency; pruning
  # devDependencies removes it, but the CLI needs it at runtime.
  dontNpmPrune = true;

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
