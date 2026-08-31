{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  llvmPackages,
  wasm-pack,
  binaryen,
}:
let
  version_tag = "cli-v0.1.0-alpha.1";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bevy_cli";
  version = "0-unstable-${version_tag}";

  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    tag = version_tag;
    hash = "sha256-v7BcmrG3/Ep+W5GkyKRD1kJ1nUxpxYlGGW3SNKh0U+8=";
  };

  cargoHash = "sha256-QrW0daIjuFQ6Khl+3sTKM0FPGz6lMiRXw0RKXGZIHC0=";

  nativeBuildInputs = [
    pkg-config
    llvmPackages.lld
    wasm-pack
    binaryen
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.libiconv
    ];

  preBuild = ''
    export PATH="${llvmPackages.lld}/bin:$PATH"
  '';

  # Skip tests that require WebAssembly compilation in the build environment
  doCheck = false;

  meta = {
    description = "Bevy CLI tool and linter";
    homepage = "https://thebevyflock.github.io/bevy_cli/";
    downloadPage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.unix;
    mainProgram = "bevy";
  };
})
