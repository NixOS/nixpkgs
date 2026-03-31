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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Aietes";
    repo = "smux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C3MsRJhD3Nr1xa1H92akTA/6jLBZ6f95/WSgcIz4haU=";
  };

  cargoHash = "sha256-8M/eliKfiYmiCvrXR9p1Q5plAPvk0MIDW4DCHGU1uxY=";

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
