{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "prettier-d-slim";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mikew";
    repo = "prettier_d_slim";
    rev = "v${version}";
    hash = "sha256-M+qlFKtIro3geVsVaYu6dIfOrJIlUQY98LSBikKNV/I=";
  };

  npmDepsHash = "sha256-zkyB3PYpfeEw5U70KewxIWd4eImIbTgy+e88264sotc=";

  dontNpmBuild = true;

  meta = {
    description = "Makes prettier fast";
    homepage = "https://github.com/mikew/prettier_d_slim";
    license = lib.licenses.mit;
    mainProgram = "prettier_d_slim";
    maintainers = with lib.maintainers; [ ];
  };
}
