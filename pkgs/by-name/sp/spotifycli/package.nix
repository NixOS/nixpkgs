{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "spotifycli";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = "spotifycli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AJysKgk58R0LwcXO0UzpgYmflJlAIqvaiyMRP8R9xGE=";
  };

  vendorHash = "sha256-MJtOJ4ZYSspumvPnK0ANL1wvWng9Na4+IlmBCoA80Hw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd spotifycli \
      --bash <($out/bin/spotifycli completion bash) \
      --zsh  <($out/bin/spotifycli completion zsh ) \
      --fish <($out/bin/spotifycli completion fish)
  '';

  meta = {
    description = "CLI to manage Spotify playlists";
    homepage = "https://github.com/doronbehar/spotifycli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "spotifycli";
  };
})
