{
  lib,
  fetchFromGitHub,
  rustPlatform,

  pkg-config,
  openssl,

  versionCheckHook,

  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agate";
  version = "3.3.23";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "mbrubeck";
    repo = "agate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6xF1iCAW4tCSoVU0rBSSfREIqPdOPF8Z1+ScMyEX4SQ=";
  };

  cargoHash = "sha256-K6BUKaVULb/x3b9UQ/wJPI/kjBIOUdLnB63FyMJEXDE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) agate;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/mbrubeck/agate";
    changelog = "https://github.com/mbrubeck/agate/releases/tag/v${finalAttrs.version}";
    description = "Very simple server for the Gemini hypertext protocol";
    mainProgram = "agate";
    longDescription = ''
      Agate is a server for the Gemini network protocol, built with the Rust
      programming language. Agate has very few features, and can only serve
      static files. It uses async I/O, and should be quite efficient even when
      running on low-end hardware and serving many concurrent requests.
    '';
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [ jk ];
  };
})
