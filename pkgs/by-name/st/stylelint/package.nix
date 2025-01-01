{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "16.12.0";
in
buildNpmPackage {
  pname = "stylelint";
  inherit version;

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-tFM4HR7n7GP+kawa1tcV/Hleb+IoCOKEHiKgULQySww=";
  };

  npmDepsHash = "sha256-ypQBWWsQiHFsU8JG+ACbKjOjYoYyoPQ6Ws3IrNgAwsU=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
