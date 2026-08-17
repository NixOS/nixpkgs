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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Aietes";
    repo = "smux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mc7sspGN4Wf8Jn995S/jsZ0v1s5kgJ0ASn9iGbzH13U=";
  };

  cargoHash = "sha256-nUJwIOdVmZR+inDz4kYpPTFXREyZyf891ATed6UFIJo=";

  __structuredAttrs = true;
  strictDeps = true;

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
