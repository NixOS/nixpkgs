{
  gitMinimal,
  lib,
  libgit2,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-instafix";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "quodlibetor";
    repo = "git-instafix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uz+KQ8cQT3v97EtmbAv2II30dUrFD0hMo/GhnqcdBOs=";
  };

  cargoHash = "sha256-B0XTk0KxA60AuaS6eO3zF/eA/cTcLwA31ipG4VjvO8Q=";

  buildInputs = [ libgit2 ];
  nativeCheckInputs = [ gitMinimal ];

  meta = {
    description = "Quickly fix up an old commit using your currently-staged changes";
    mainProgram = "git-instafix";
    homepage = "https://github.com/quodlibetor/git-instafix";
    changelog = "https://github.com/quodlibetor/git-instafix/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      mightyiam
      quodlibetor
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
