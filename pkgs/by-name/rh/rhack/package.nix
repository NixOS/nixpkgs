{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhack";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "rhack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZwjUyB8oWd8KfImjeOwtH4DI+bBacd6vQUp9XYyzHiE=";
  };

  cargoHash = "sha256-84dVBNvo45zG7s/tMY3O0Zv69CdcvjZCZX8siie6QnI=";

  meta = {
    description = "Temporary edit external crates that your project depends on";
    mainProgram = "rhack";
    homepage = "https://github.com/nakabonne/rhack";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
