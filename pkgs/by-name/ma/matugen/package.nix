{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    rev = "v${version}";
    hash = "sha256-WFitpFF1Ah4HkzSe4H4aN/ZM0EEIcP5ozLMUWaDggFU=";
  };

  cargoHash = "sha256-pD1NKUJmvMTnYKWjRrGnvbA0zVvGpWRIlf/9ovP9Jq4=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}
