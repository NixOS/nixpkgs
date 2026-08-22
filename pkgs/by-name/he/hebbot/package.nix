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
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hebbot";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "hebbot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-log2h3mWSBQu1zjki6mMW7Lcph2dht0ksVkdacum0Jc=";
  };

  cargoHash = "sha256-cfHD66uf6zIeml69VRGy9bjbdS3PkOfNBdTam5UCzso=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoconf
    automake
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    NIX_CFLAGS_LINK = toString [
      "-L${lib.getLib openssl}/lib"
      "-L${lib.getLib sqlite}/lib"
    ];
  };

  meta = {
    description = "Matrix bot which can generate \"This Week in X\" like blog posts ";
    homepage = "https://github.com/haecker-felix/hebbot";
    changelog = "https://github.com/haecker-felix/hebbot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ agpl3Only ];
    mainProgram = "hebbot";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
})
