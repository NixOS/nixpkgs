{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ldproxy";
  version = "0.31.4";

  # The source of this tools actually comes from the set of tools located in the `esp-rs:embuild` repository
  # cf: https://github.com/esp-rs/embuild
  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "embuild";
    rev = "v${version}";
    hash = "sha256-YH2CPb3uBlPncd+KkP25xhCVvDB7HDxJuSqWOJ1LT3k=";
  };

  cargoHash = "sha256-HobX/aBn10KPpUKRSLt2IvfFVW7YpOu5tX4zNSCz6tw=";

  # However we are only interested in building the specific crate located at `/ldproxy`
  # cf: https://github.com/esp-rs/embuild/tree/v0.31.4/ldproxy
  buildAndTestSubdir = "ldproxy";

  meta = with lib; {
    description = "Linker Proxy: a simple tool to forward linker arguments to the actual linker executable";
    homepage = "https://github.com/esp-rs/embuild";
    changelog = "https://github.com/esp-rs/embuild/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ vpochapuis ];
  };
}
