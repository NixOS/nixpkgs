{
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
}:

buildNpmPackage rec {
  pname = "defuddle-cli";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle-cli";
    tag = "${version}";
    hash = "sha256-28XmpFKzBKNhRkPOGaacJVw8hjQUZq2nwuR0vNo8aW0=";
  };

  npmDepsHash = "sha256-rRo+ty/E09OS+cWDnKQkROEdDc0hiB5g1h/+NbJe+/M=";

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Command line utility to extract clean html, markdown and metadata from web pages";
    homepage = "https://github.com/kepano/defuddle-cli";
    license = lib.licenses.mit;
    mainProgram = "defuddle";
    maintainers = with lib.maintainers; [ surfaceflinger ];
  };
}
