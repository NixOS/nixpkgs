{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  xz,
  stdenv,
  darwin,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "refs/tags/v${version}";
    hash = "sha256-OfTMJ7ylVOJjL295W3Flj2upTiUQXmfkyDFSE1v8+a4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dphMJ1KkZARSntvyEayAtlYw8lL39K7Iw0X4n8nz3z8=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      openssl
      xz
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    OPENSSL_NO_VENDOR = true;
  };

  postPatch = ''
    # Fix for "Found argument '--test-threads' which wasn't expected, or isn't valid in this context"
    substituteInPlace tests/src/tests.rs --replace-fail 'ARGS.num_threads' 'ARGS.test_threads'
    substituteInPlace tests/src/args.rs --replace-fail 'num_threads' 'test_threads'
  '';

  postInstall = ''
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
  '';

  cargoTestFlags = [ "--workspace" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/typst/typst/releases/tag/v${version}";
    description = "New markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://github.com/typst/typst";
    license = lib.licenses.asl20;
    mainProgram = "typst";
    maintainers = with lib.maintainers; [
      drupol
      figsoda
      kanashimia
    ];
  };
}
