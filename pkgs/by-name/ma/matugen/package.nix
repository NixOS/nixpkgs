{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    rev = "refs/tags/v${version}";
    hash = "sha256-SN4m0ka5VHLIQYTszhlCIB+2D+nyWMzJM5n5bZdkG/I=";
  };

  cargoHash = "sha256-FwQhhwlldDskDzmIOxhwRuUv8NxXCxd3ZmOwqcuWz64=";

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
