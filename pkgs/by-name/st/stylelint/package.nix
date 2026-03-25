{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-LQqKAKVdFJkIZQDwv2X6dxGDFPZ3xdTQIx+8kAlijDU=";
  };

  npmDepsHash = "sha256-FdFM1Mo/P7jw+0nY8kR4ThTLJDxG8fp/tZiYSFzRSac=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
