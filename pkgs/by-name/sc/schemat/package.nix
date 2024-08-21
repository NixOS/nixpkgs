{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage {
  name = "schemat";
  version = "0.2.9-unstable-2024-08-20";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    rev = "9dc2265aec54273c0abc8f60aba4c94408129006";
    hash = "sha256-2nIzM6qW4lJCF8vg3q4NaBSlO5HttRTYyLN5KQMoRVs=";
  };

  cargoHash = "sha256-/CH3KFd4r2hwLu1UeEfpKknmIZ/Ls4/EtkLAs+EdSfk=";

  RUSTC_BOOTSTRAP = true;

  patches = [ ./enable-error_in_core.patch ];

  meta = {
    description = "Code formatter for Scheme, Lisp, and any S-expressions";
    homepage = "https://github.com/raviqqe/schemat";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "schemat";
  };
}
