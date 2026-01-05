{
  lib,
  mdbook,
  nodejs,
  python3,
  util-linux,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-cmdrun";
  version = "0.7.3-unstable-2025-12-22";

  # mdbook 0.5 upgrade: https://github.com/FauconFan/mdbook-cmdrun/pull/23
  src = fetchFromGitHub {
    owner = "roberth";
    repo = "mdbook-cmdrun";
    rev = "3947c797d063352e0f983311c078430215cc1cca";
    hash = "sha256-0RkyMJ8tsnGcSD0ksGTGAyliH6AihVl0HEesljEmTH8=";
  };

  nativeCheckInputs = [
    mdbook # used by tests/book.rs
    nodejs # used by tests/regression/inline_call/input.md
    python3 # used by tests/regression/py_*
    util-linux # used by tests/regression/shell/input.md
  ];

  cargoHash = "sha256-oUlH+z50a1FtzDADXfGKSYjauZGTok0bVMq718HLglY=";

  meta = {
    description = "mdbook preprocessor to run arbitrary commands";
    mainProgram = "mdbook-cmdrun";
    homepage = "https://github.com/FauconFan/mdbook-cmdrun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pinpox
      matthiasbeyer
    ];
  };
}
