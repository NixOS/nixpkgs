{ lib, buildNpmPackage, fetchFromGitHub, nix-update-script }:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tu6SKeTVEqIqDJXimoSkMK9+l0uGqWSrlIO0KHoROSQ=";
  };

  npmDepsHash = "sha256-13RiEBLhmKW04Tesg1s7c9rCYtRGOd/prnVARb6jpGQ=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
    mainProgram = "terminal-stocks";
  };
}
