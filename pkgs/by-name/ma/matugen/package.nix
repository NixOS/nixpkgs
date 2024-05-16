{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    rev = "v${version}";
    hash = "sha256-4VX7Rt+ftEH8nwg59eT7TsvHYUf8/euUmwh/JLc4rLc=";
  };

  cargoHash = "sha256-axBdOzCUwseV2ltgarmIS3IOYLX3q3rXeA2y6y7aNFI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "A material you color generation tool";
    homepage = "git@github.com:InioX/matugen.git";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}
