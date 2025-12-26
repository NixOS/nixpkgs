{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "managarr";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${version}";
    hash = "sha256-RBJ4Z5WTArQ/fG3Bv6wHAPJzRJNrIGTNphPYjV8Ocqc=";
  };

  cargoHash = "sha256-om4zGqh4bEgQZ+G2/MVGi9SCbopLdZ2K8hjIPIefiSQ=";

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
