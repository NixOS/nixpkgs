{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  matrix-synapse-unwrapped,
  nix-update-script,
  twisted,
}:

buildPythonPackage rec {
  pname = "synapse-http-antispam";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "synapse-http-antispam";
    tag = "v${version}";
    hash = "sha256-YvgHIZ5Kr9WsX30QN8W5OJ4sxLB7EsLqUmCye3x+JQA=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "synapse_http_antispam" ];

  buildInputs = [ matrix-synapse-unwrapped ];
  dependencies = [ twisted ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Synapse module that forwards spam checking to an HTTP server";
    homepage = "https://github.com/maunium/synapse-http-antispam";
    changelog = "https://github.com/maunium/synapse-http-antispam/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sumnerevans ];
  };
}
