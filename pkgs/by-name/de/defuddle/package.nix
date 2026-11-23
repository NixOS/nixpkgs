{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "defuddle";
  version = "untagged-a48a23dbc4e902c144b3";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = version;
    hash = "sha256-vBme4u+ZRXpnj/f9SFt1aBdfjUjVd7SJ58MAmmK81lE=";
  };

  npmDepsHash = "sha256-yiXpFhoVGTK0GWoDF92X1TVt9gaBMhtie0zyuVMeqxM=";

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
