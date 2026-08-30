{
  gitMinimal,
  lib,
  libgit2,
  oniguruma,
  pkg-config,
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

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    oniguruma
  ];

  nativeCheckInputs = [ gitMinimal ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

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
