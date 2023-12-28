{
  darwin,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "relnotes";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "relnotes";
    rev = "v${version}";
    hash = "sha256-3Jv5GTB528wZRpQlJtoqqTEL0OA9Cf0htgZbS5H4Xrw=";
  };

  cargoHash = "sha256-earxhVkEhHZipvSHTKzoINIq0/PGyt6CY35mv+ksv1E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ]
    ++ lib.optionals stdenv.isLinux [ (lib.getDev openssl) ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://github.com/EmbarkStudios/relnotes";
    description = "Automatic GitHub Release Notes";
    changelog = "https://github.com/EmbarkStudios/relnotes/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "relnotes";
    maintainers = with lib.maintainers; [ david-r-cox ];
    platforms = lib.platforms.darwin;
  };
}
