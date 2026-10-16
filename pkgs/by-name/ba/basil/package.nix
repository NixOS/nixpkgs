{
  lib,
  buildPackages,
  cacert,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  protobuf,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "basil";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "openbasil";
    repo = "basil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ODBl5s8r4iGfGMg8StnIPMsEQhiUR8wEnzQWNieg3Q=";
  };

  cargoHash = "sha256-g0orXGEK3JiTboPtrtJuEZKxf3n2R6vppD6W5StifTk=";

  # Build only the two shipped binaries, plus the xtask helper that renders
  # their man pages. xtask is removed again in postInstall — it is a build
  # tool, not part of the distribution.
  cargoBuildFlags = [
    "-p"
    "basil-bin"
    "-p"
    "basil-nats-bridge"
    "-p"
    "xtask"
  ];

  nativeBuildInputs = [
    installShellFiles
    protobuf
  ];

  env = {
    PROTOC = lib.getExe' protobuf "protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
    # The test suite builds reqwest clients whose platform verifier loads the
    # OS CA trust store even for tests that never touch the network; the
    # build sandbox has no /etc/ssl, so point at nixpkgs' bundle.
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # install man pages and shell completions
  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir -p $out/share/man/man1
      ${emulator} $out/bin/xtask -o $out/share/man/man1
      rm $out/bin/xtask

      installShellCompletion --cmd basil \
        --bash <(${emulator} $out/bin/basil completions bash)  \
        --zsh <(${emulator} $out/bin/basil completions zsh) \
        --fish <(${emulator} $out/bin/basil completions fish)
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Host-local secrets broker that keeps keys in the backend, used in place";
    homepage = "https://github.com/openbasil/basil";
    changelog = "https://github.com/openbasil/basil/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stevelr ];
    mainProgram = "basil";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
