{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  cmake,
  openssl,
  autoconf,
  automake,
  darwin,
  unstableGitUpdater,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "hebbot";
  version = "2.1-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "hebbot";
    rev = "4c7152a3ce88ecfbac06f823abd4fd849e0c30d1";
    hash = "sha256-y+KpxiEzVAggFoPvTOy0IEmAo2V6mOpM0VzEScUOtsM=";
  };

  cargoHash = "sha256-7AEWQIUHpeK4aNFzzU10YeJErD0fJ6yQSHwFe4utOFo=";

  nativeBuildInputs =
    [
      pkg-config
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      autoconf
      automake
    ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  NIX_CFLAGS_LINK = [
    "-L${lib.getLib openssl}/lib"
    "-L${lib.getLib sqlite}/lib"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Matrix bot which can generate \"This Week in X\" like blog posts ";
    homepage = "https://github.com/haecker-felix/hebbot";
    changelog = "https://github.com/haecker-felix/hebbot/releases/tag/v${version}";
    license = with lib.licenses; [ agpl3Only ];
    mainProgram = "hebbot";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
}
