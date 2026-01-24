{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-maintained";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "JonathanWoollett-Light";
    repo = "cargo-maintained";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-YKwQjeJf4vZQO6r8ngG0faxVAmxmlKmMhsA9nbdtsbg=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-BJ0Mky86kf+KDiPh2HuLsaY/ixxUL96P0mcywC7/iCc=";

  meta = {
    description = "tool to check crates are up to date";
    homepage = "https://github.com/JonathanWoollett-Light/cargo-maintained";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "cargo-maintained";
  };
})
