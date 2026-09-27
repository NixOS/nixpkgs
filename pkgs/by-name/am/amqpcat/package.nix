{
  lib,
  fetchFromGitHub,
  crystal,
  openssl,
  testers,
  amqpcat,
}:

crystal.buildCrystalPackage rec {
  pname = "amqpcat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "amqpcat";
    tag = "v${version}";
    hash = "sha256-wUsDqatZVcfvtTlK4eOYvFFCyyO8nkrBksvN6Od4DG0=";
  };

  format = "shards";
  shardsFile = ./shards.nix;

  buildInputs = [ openssl ];

  preConfigure = ''
    substituteInPlace "./src/version.cr" --replace-fail \
      'VERSION = {{ `git describe 2>/dev/null || shards version`.stringify.gsub(/(^v|\n)/, "") }}' \
      'VERSION = "${version}"'
  '';

  # Tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = amqpcat;
  };

  meta = {
    description = "CLI tool for publishing to and consuming from AMQP servers";
    mainProgram = "amqpcat";
    homepage = "https://github.com/cloudamqp/amqpcat";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
