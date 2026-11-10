{
  lib,
  stdenv,
  fetchFromGitHub,
  bashNonInteractive,
  installShellFiles,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bashcards";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rpearce";
    repo = "bashcards";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKqXX3+E5zZ5zYlfUT8q7VF8MFi8zCVH/pc6BPLX5v8=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ bashNonInteractive ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bashcards -t "$out/bin"
    installManPage bashcards.1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Practice flashcards in bash";
    homepage = "https://github.com/rpearce/bashcards/";
    changelog = "https://github.com/rpearce/bashcards/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rpearce ];
    platforms = lib.platforms.all;
    mainProgram = "bashcards";
  };
})
