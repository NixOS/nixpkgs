{
  fetchFromGitHub,
  lib,
  libgit2,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "affected";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Rani367";
    repo = "affected";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dRf1SMCIqRm4loIosakb0YO9vAe6rpAPKNdVYWvFKYA=";
  };

  cargoHash = "sha256-POXMKm2RHXdlUZbj0ESv9JWlhBQWUrnukxa7KhzIRt4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env.OPENSSL_NO_VENDOR = true;

  doCheck = false; # https://github.com/Rani367/affected/issues/3
  preCheck = ''
    RUST_BACKTRACE=full
  '';

  # https://github.com/Rani367/affected/issues/4
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Rani367/affected/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Detect affected packages and run only what matters";
    longDescription = ''
      Standalone, language-agnostic CLI that detects which packages in
      your monorepo are affected by git changes — then runs tests,
      lints, builds, or any command on only those packages.  No
      framework, no config files, no no lock-in.
    '';
    homepage = "https://github.com/Rani367/affected";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "affected";
  };
})
