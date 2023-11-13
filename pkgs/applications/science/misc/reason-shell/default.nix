{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "reason";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "jaywonchung";
    repo = "reason";
    rev = "v${version}";
    hash = "sha256-oytRquZJgb1sfpZil1bSGwIIvm+5N4mkVmIMzWyzDco=";
  };

  cargoHash = "sha256-4AEuFSM2dY6UjjIFRU8ipkRMoEb2LjnOr3H6rZrLokE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A shell for research papers";
    homepage = "https://github.com/jaywonchung/reason";
    changelog = "https://github.com/jaywonchung/reason/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
