{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
<<<<<<< HEAD
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oha";
  version = "1.12.1";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "1.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yz9RuYUwwvXef0XzVHCv5/uzT6KGz+tQVMRVUJN81zU=";
  };

  cargoHash = "sha256-suHyApGbRF8KaH9Xb47zvnoenPIA7NdiULuvUXViLu0=";

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
=======
    tag = "v${version}";
    hash = "sha256-N52j8WYEVlmHQdr0HZJZZo92OhIz4V0R1SdaWlOD684=";
  };

  cargoHash = "sha256-M6wJy5X9JRM9tOOGT8b6YIUT0OakXQxjw17iuqaRT5s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    rust-jemalloc-sys
  ];

  # tests don't work inside the sandbox
  doCheck = false;

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jpds ];
    mainProgram = "oha";
  };
})
=======
  meta = {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "oha";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
