# <https://github.com/devsnek/node-register-scheme>
{ buildNpmPackage
, fetchFromGitHub
, python3
, bindings
}:

buildNpmPackage rec {
  pname = "node-register-scheme";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "devsnek";
    repo = pname;
    rev = "e7cc9a63a1f512565da44cb57316d9fb10750e17";
    hash = "sha256-xu9JmhsCenqB4A3i9BUIwaGuc88y7qzKULBeqT9jnkg=";
  };

  nativeBuildInputs = [ python3 ];

  npmDepPath_bindings = "${bindings}/lib/node_modules/bindings";
  prePatch = ''
    substituteAll ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    cp package-lock.json $out/lib/node_modules/register-scheme/
  '';

  npmDepsHash = "sha256-ZServA3WcgB7D80uileqMqU4QZ1jmcetv9KblhkeB/Y=";
}
