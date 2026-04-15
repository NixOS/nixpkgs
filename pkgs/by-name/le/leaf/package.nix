{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaf";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "IogaMaster";
    repo = "leaf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y0NO9YcOO7T7Cqc+/WeactwBAkeUqdCca87afOlO1Bk=";
  };

  cargoHash = "sha256-RQ9fQfYfpsFAA5CzR3ICLIEYb00qzUsWAQKSrK/488g=";

  meta = {
    description = "Simple system fetch written in rust";
    homepage = "https://github.com/IogaMaster/leaf";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "leaf";
  };
})
