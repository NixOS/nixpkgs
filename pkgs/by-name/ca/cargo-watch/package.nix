{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-watch";
  version = "8.5.3";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "cargo-watch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-agwK20MkvnhqSVAWMy3HLkUJbraINn12i6VAg8mTzBk=";
  };

  cargoHash = "sha256-4AVZ747d6lOjxHN+co0A7APVB5Xj6g5p/Al5fLbgPnc=";

  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${stdenv.hostPlatform.rust.rustcTarget}/release:$PATH"
  '';

  meta = {
    description = "Cargo subcommand for watching over Cargo project's source";
    mainProgram = "cargo-watch";
    homepage = "https://github.com/watchexec/cargo-watch";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      xrelkd
      ivan
      matthiasbeyer
    ];
  };
})
