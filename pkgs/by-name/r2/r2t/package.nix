{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "r2t";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "T00fy";
    repo = "r2t";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aA2TRYZBj+dpqxvWxek3qqhezFCFsYNDrqE0AGcypxA=";
  };

  cargoHash = "sha256-5Kq16XLyuNd7QaRdDj+rx9KxkVrYNp/itQvFxOpc2Ns=";

  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "r2t --version";
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Convert a repository into a single, well-structured text file for LLMs";
    homepage = "https://github.com/T00fy/r2t";
    changelog = "https://github.com/T00fy/r2t/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "r2t";
    maintainers = with maintainers; [ Kh05ifr4nD ];
    platforms = platforms.unix ++ platforms.darwin;
  };
})
