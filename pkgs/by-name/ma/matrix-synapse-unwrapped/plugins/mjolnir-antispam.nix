{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  matrix-synapse-unwrapped,
}:

buildPythonPackage rec {
  pname = "matrix-synapse-mjolnir-antispam";
  version = "1.12.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    tag = "v${version}";
    sha256 = "sha256-PWPtp1KVOBNH7lu99Yy3hmj8wGOZe+YKjPq/SyO7oLM=";
  };

  sourceRoot = "${src.name}/synapse_antispam";

  buildInputs = [ matrix-synapse-unwrapped ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "mjolnir" ];

  meta = {
    description = "AntiSpam / Banlist plugin to be used with mjolnir";
    longDescription = ''
      Primarily meant to block invites from undesired homeservers/users,
      Mjolnir's Synapse module is a way to interpret ban lists and apply
      them to your entire homeserver.
    '';
    homepage = "https://github.com/matrix-org/mjolnir/blob/main/docs/synapse_module.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jojosch ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
