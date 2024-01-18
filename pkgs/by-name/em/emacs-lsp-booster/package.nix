{
  lib,
  rustPlatform,
  fetchFromGitHub,
  emacs,
}:
rustPlatform.buildRustPackage rec {
  pname = "emacs-lsp-booster";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "blahgeek";
    repo = "emacs-lsp-booster";
    rev = "v${version}";
    hash = "sha256-DmEnuAR/OtTdKApEWCdOPAJplT29kuM6ZSHeOnQVo/c=";
  };

  cargoHash = "sha256-2wXsPkBl4InjbdYUiiQ+5fZFanLA88t5ApGZ4psfDqk=";

  nativeCheckInputs = [emacs]; # tests/bytecode_test

  meta = with lib; {
    description = "Emacs LSP performance booster";
    homepage = "https://github.com/blahgeek/emacs-lsp-booster";
    license = licenses.mit;
    maintainers = with maintainers; [icy-thought];
    mainProgram = "emacs-lsp-booster";
  };
}
