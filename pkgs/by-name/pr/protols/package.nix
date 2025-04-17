{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-APGjh6+dNubxiyS5BI6pMXMBQ50ij6NnxSWZlbJ7FWk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-L9nOVgfLoZDqKWsLBG9ph0TmlPej13S3KmgbLcumw8I=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
