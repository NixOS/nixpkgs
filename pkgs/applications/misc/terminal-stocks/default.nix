{ lib, buildNpmPackage, fetchFromGitHub, nix-update-script }:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AzLMqp5t9u1ne+xCKp0dq/3V3DKJ1Ou9riAN+KqkStg=";
  };

  npmDepsHash = "sha256-GOg6B8BWkWegxeYmlHSJjFNrb/frb6jdzjjNSGF38Zo=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
  };
}
