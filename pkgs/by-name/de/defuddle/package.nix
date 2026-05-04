{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "defuddle";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = version;
    hash = "sha256-e/+eigIzpP0g+ZqTeyZnF6mloaY6UeKcMWfqryCcLbM=";
  };

  npmDepsHash = "sha256-1NFwhYEGTKpjzCdK/eHK0TWtOEpn67FA+B3QZ11w1Rs=";

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
