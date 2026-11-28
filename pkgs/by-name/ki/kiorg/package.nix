{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kiorg";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "houqp";
    repo = "kiorg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gagC6qpWJvNf3aMJyKU5dQLGYk2vZwURi86ISc3JqFU=";
  };

  cargoHash = "sha256-prZHwCrLzAhwuiENN89MPHO0VHGCkWmMh/qGgzfwwzU=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "A hacker's file manager with VIM inspired keybind";
    homepage = "https://github.com/houqp/kiorg";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ambroisie ];
    mainProgram = "kiorg";
  };
})
