{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
}:

buildNpmPackage rec {
  pname = "balanceofsatoshis";
  version = "19.4.10";

  src = fetchFromGitHub {
    owner = "alexbosworth";
    repo = "balanceofsatoshis";
    tag = "v${version}";
    hash = "sha256-WJuxe3k8ZLlkB5SpvE1DSyxQsc5bYEKVsM8tt5vdYOU=";
  };

  npmDepsHash = "sha256-dsWYUCPbiF/L3RcdcaWVn6TnU1/XMy9l7eQgHrBYW4o=";

  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  meta = {
    changelog = "https://github.com/alexbosworth/balanceofsatoshis/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for working with the balance of your satoshis on LND";
    homepage = "https://github.com/alexbosworth/balanceofsatoshis";
    license = lib.licenses.mit;
    mainProgram = "bos";
    maintainers = with lib.maintainers; [ mariaa144 ];
  };
}
