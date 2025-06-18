{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-aMQrPJp0AVEYfMlWZBy9IMvQQxlkW7KWuxqLn1Ds2ck=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5uMz1j0ZnA4wPMfC2SeY33zsiTt2NNZnWh9th2UJiNI=";

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
