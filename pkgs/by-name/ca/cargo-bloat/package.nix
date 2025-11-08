{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "cargo-bloat";
    rev = "v${version}";
    hash = "sha256-B71VX7cJe1giOLmk3cQE8Zxr7fKGyQkoXRuM+NzBcb8=";
  };

  cargoHash = "sha256-8Omw8IsmoFYPBB6q1EAAbcBhTjBWfCChV2MhX9ImY8Y=";

  meta = with lib; {
    description = "Tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      xrelkd
      matthiasbeyer
    ];
    mainProgram = "cargo-bloat";
  };
}
