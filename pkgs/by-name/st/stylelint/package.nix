{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.26.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-Lw36rmGNoqobDoMdzYX7JaOFTyFGmjiBe55WI9RgAlY=";
  };

  npmDepsHash = "sha256-CCvyJzLCXbuipBXJrLdkAv/dT9RoZNhbwrUZhSaja8s=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
