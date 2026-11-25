{
  lib,
  fetchFromGitHub,
  aws-lc,
  cacert,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
  nix-update-script,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-commander-rs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bdfdnMhV1O13iDL8WwL4pX8y6DTfHdBULaXdvcYObYk=";
  };

  cargoHash = "sha256-jsPrjoAovyGeXe+ZFs2iIHC6Bs1hZv0hTFNPvvSwoqQ=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    aws-lc
    openssl
    sqlite
  ];

  nativeCheckInputs = [ cacert ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(0.*)$" # https://github.com/8go/matrix-commander-rs/issues/194#issuecomment-4864773450
    ];
  };

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      ilkecan
    ];
    mainProgram = "matrix-commander-rs";
  };
})
