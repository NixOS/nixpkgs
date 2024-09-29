{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  cargo,
  rustfmt,
  cargo-show-asm,
  cargo-expand,
  clang,
  # Workaround to allow easily overriding runtime inputs
  runtimeInputs ? [
    cargo
    rustfmt
    cargo-show-asm
    cargo-expand
    clang
  ],
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "irust";
  version = "1.71.24";

  src = fetchFromGitHub {
    owner = "sigmaSd";
    repo = "IRust";
    rev = "irust@${version}";
    hash = "sha256-L9iSTa0KlAXVYA1PgLaxB0eHoOGrzGE49Km3jBq4jWo=";
  };

  cargoHash = "sha256-nF6tmA7IcgPG8EoFzwJa7zYKx9ezhpjIIa1tZLO0rvQ=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/irust \
      --suffix PATH : ${lib.makeBinPath runtimeInputs}
  '';

  checkFlags = [
    "--skip=repl"
    "--skip=printer::tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Cross Platform Rust Repl";
    homepage = "https://github.com/sigmaSd/IRust";
    license = licenses.mit;
    maintainers = with maintainers; [ lelgenio ];
    mainProgram = "irust";
  };
}
