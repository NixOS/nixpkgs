{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = "mdbook-admonish";
    tag = "v${version}";
    hash = "sha256-rlJowyyB83bNqzOavggbwVJg9/GYZLYjGr8Pv/O6UBE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ilX/Tky3eQB0Aumz+gRRyaVz/MAM/qiNrGulZSPGUg0=";

  meta = {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jmgilman
      Frostman
      matthiasbeyer
    ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
