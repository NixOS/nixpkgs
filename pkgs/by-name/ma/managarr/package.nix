{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "managarr";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${version}";
    hash = "sha256-6aqJxnhc1eXqJIuX07aKSEooNeVwnq8ic7yZnJaokR8=";
  };

  cargoHash = "sha256-BdgJVByyJ7Nq8gjPXxSaeQQYVQRM/leTd9AxWd7IpDw=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.IncredibleLaser
      lib.maintainers.darkalex
      lib.maintainers.nindouja
    ];
    mainProgram = "managarr";
  };
}
