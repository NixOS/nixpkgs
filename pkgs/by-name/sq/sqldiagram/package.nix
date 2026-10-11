{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule {
  pname = "sqldiagram";
  version = "0";

  src = fetchFromGitHub {
    owner = "RadhiFadlillah";
    repo = "sqldiagram";
    hash = "sha256-brBiGxngGLNaQHqMY8jJ2CUhtca606Oxho4rXX7JVXM=";
    rev = "958b1d870b9ab100db6a758dd53d153ba6fa7118";
  };

  vendorHash = "sha256-IjAiu9CLAjTxCuZlZoJJZqs9rWG1zeHPBjY+sY7xJRM=";

  meta = {
    description = "CLI to generate Entity Relationship Diagram from SQL file";
    homepage = "https://github.com/RadhiFadlillah/sqldiagram";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Fovir ];
    mainProgram = "sqldiagram";
  };
}
