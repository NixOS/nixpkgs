{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  cmake,
  pkg-config,
  openssl,
  libiconv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kellnr";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "kellnr";
    repo = "kellnr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aBPLEZBRJ1DkmpBmqhhk7lAyfx9dN5vtwNcRhCtJEZg=";
  };

  cargoHash = "sha256-+41c4g5Ua7kLvO0Tv02W4C1wrqvbgy+D0Dppczw6ONk=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  OPENSSL_DIR = "${openssl.dev}";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_NO_VENDOR = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://github.com/kellnr/kellnr" ];
  };

  meta = {
    description = "Open-source Rust registry for crates";
    longDescription = ''
      Host your private Rust crates on your own infrastructure.
      Full control. Complete privacy. Zero dependencies on external services.
    '';
    homepage = "https://kellnr.io";
    changelog = "https://github.com/kellnr/kellnr/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "kellnr";
  };
})
