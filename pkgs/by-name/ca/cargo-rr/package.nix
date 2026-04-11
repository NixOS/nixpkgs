{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  rr,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = "cargo-rr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-t8pRqeOdaRVG0titQhxezT2aDjljSs//MnRTTsJ73Yo=";
  };

  cargoHash = "sha256-s3KZFntAb/q4oreJLDQ2Pnz+Oj8Ik36vYR2InY0BIBw=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    mainProgram = "cargo-rr";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      otavio
      matthiasbeyer
    ];
  };
})
