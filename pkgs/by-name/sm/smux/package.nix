{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  tmux,
  fzf,
  zoxide,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smux";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Aietes";
    repo = "smux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pmTQTw6HayQK8g+W39UVJe35TVgUEM6tcbzWNCOBeSQ=";
  };

  cargoHash = "sha256-Td61UrS83rqd5g50gEEARkE0/uMnOMUytF5XSW4pJVI=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/smux completions zsh --dir completions
    installShellCompletion --zsh completions/_smux

    $out/bin/smux man --dir man
    installManPage man/*.1
    installManPage man/*.5
  '';

  postFixup = ''
    wrapProgram $out/bin/smux \
      --prefix PATH : ${
        lib.makeBinPath [
          tmux
          fzf
          zoxide
        ]
      }
  '';

  meta = {
    description = "Tmux session manager with fzf-powered project and template selection";
    homepage = "https://github.com/Aietes/smux";
    license = lib.licenses.mit;
    mainProgram = "smux";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aietes ];
  };
})
