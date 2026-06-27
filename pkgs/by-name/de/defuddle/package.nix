{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "defuddle";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = version;
    hash = "sha256-Fn203XKjZ2qbM1o0zs6mgxCdjWLOwz9Na+s1WSQG9XM=";
  };

  npmDepsHash = "sha256-quqWhbcaSNj4Bk++4N4LYq3Y8U5nQqnwc+MqU0LLgso=";

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
