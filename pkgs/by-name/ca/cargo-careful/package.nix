{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-aKmaNDk9yZ/1MS3vQ9c1rCySfxiNv8PRwnIjT5bdhMg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KtTTpYwhNYvghb8k2NXyCRV5NGn07d7iaW+5uTI6qJ4=";

  meta = with lib; {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
