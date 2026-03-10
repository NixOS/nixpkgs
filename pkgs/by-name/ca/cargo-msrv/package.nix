{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup,
  openssl,
  stdenv,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-msrv";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "cargo-msrv";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-GsreJpQ+WsiKIRbQx4gXyH24JnoMUgJSVLFvljWxJq8=";
  };

  cargoHash = "sha256-+7O+9wS72QCHNYcXJUFyc4I9PFH5B8OvisVKf5bBDdY=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  # Integration tests fail
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      otavio
      matthiasbeyer
    ];
  };
})
