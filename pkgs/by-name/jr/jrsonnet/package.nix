{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jrsonnet";
  version = "0.5.0-pre98";

  src = fetchFromGitHub {
    owner = "CertainLach";
    repo = "jrsonnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2dNzxZnvnw8TsKnnIlHGpuixrqe4z0a4faOBPv2N+ws=";
  };

  cargoHash = "sha256-QPJ1kVk/TftAROiBVBN6J4PZ1pwjtjldtgmJxSTC1Ao=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s $out/bin/jrsonnet $out/bin/jsonnet
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd jrsonnet \
        --$shell <($out/bin/jrsonnet generate $shell)
      installShellCompletion --cmd jsonnet \
        --$shell <($out/bin/jrsonnet generate $shell | sed s/jrsonnet/jsonnet/g)
    done
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    homepage = "https://github.com/CertainLach/jrsonnet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lach
    ];
  };
})
