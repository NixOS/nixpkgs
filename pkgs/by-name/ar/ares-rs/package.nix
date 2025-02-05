{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "ares-rs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "ares";
    tag = "v${version}";
    hash = "sha256-J+q7KeBthF9Wd08MNv0aHyLHgLUKg3mzQ8ic6+ashto=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K4qAUEVdi7OqpKAxyEMnKkGTuxSjrdE+UQaYosnUo70=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Automated decoding of encrypted text without knowing the key or ciphers used";
    homepage = "https://github.com/bee-san/ares";
    changelog = "https://github.com/bee-san/Ares/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ares";
  };
}
