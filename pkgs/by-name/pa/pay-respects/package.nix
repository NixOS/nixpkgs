{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pay-respects";
  version = "0.7.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-NmFuu6uS8maAoN9U2ZdEyeJeozR3ubhoMrhvWKDxbMI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xqq4PXvon6edjJ4VhrhXD8QtDGWlMeJnl8mnH8rdIvU=";

  meta = {
    description = "Terminal command correction, alternative to `thefuck`, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
      bloxx12
      ALameLlama
    ];
    mainProgram = "pay-respects";
  };
}
