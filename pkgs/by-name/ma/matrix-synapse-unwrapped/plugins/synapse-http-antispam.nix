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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "synapse-http-antispam";
    tag = "v${version}";
    hash = "sha256-wWm23+3o+/nx3xGkyShJm28mDPTbOhPbKgW3WfuB0Ng=";
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
