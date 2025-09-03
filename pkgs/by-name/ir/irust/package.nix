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
  version = "1.76.1";

  src = fetchFromGitHub {
    owner = "sigmaSd";
    repo = "IRust";
    rev = "irust@${version}";
    hash = "sha256-rNPB+POWDT6DKoqowHFmojNluFWjd+lXzYYsc9I6ebU=";
  };

  cargoHash = "sha256-OGK5CzDuA1sWmZgh2OCQBiTvGLdTjMALFnPXM5pYZo4=";

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
