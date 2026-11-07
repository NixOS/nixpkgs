{
  lib,
  installShellFiles,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "plyx";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "TheRedDeveloper";
    repo = "plyx";
    tag = finalAttrs.version;
    hash = "sha256-sk4Ss8F+OT+TBC+1600OHubIJ38hrb9qsbKvH1eOJp0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  checkFlags = [
    # Disable tests that require internet access, which is not available during builds.
    "--skip=fonts::tests::test_download_lexend"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd plyx \
      --bash <($out/bin/plyx completions bash) \
      --fish <($out/bin/plyx completions fish) \
      --zsh <($out/bin/plyx completions zsh)
  '';

  __structuredAttrs = true;

  meta = {
    description = "CLI helper for building Rust GUI application with ply";
    homepage = "https://plyx.iz.rs/";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ jthulhu ];
  };
})
