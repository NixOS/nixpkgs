{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pay-respects";
  version = "0.4.18";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-8YQgNOqZAMhn93rk0fw1SV02XhI/Wt9D5Rzo64cCs7s=";
  };

  cargoHash = "sha256-xLAJLwzX923E7Pzfwdw38moLOlY0Q4xK8himbKHQ7O8=";

  meta = {
    description = "Terminal command correction, alternative to `thefuck`, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sigmasquadron ];
    mainProgram = "pay-respects";
  };
}
