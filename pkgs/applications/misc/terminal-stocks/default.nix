{ lib, buildNpmPackage, fetchFromGitHub, nix-update-script }:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8n+Wpkiy+XTaIBO7nuxO2m3EkkaHsmYNqtUqMin6leg=";
  };

  npmDepsHash = "sha256-M9a33v1R/cAgUJJLHwPs8hpPtjzzKkMps/ACnWLqUZE=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
  };
}
