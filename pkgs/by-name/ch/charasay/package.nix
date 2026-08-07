{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "charasay";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = "charasay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8N3ToXpbDR+g19CT0q1J4QfQstBjS2QfX4IV2D7+ics=";
  };

  cargoHash = "sha256-yByNgG8JAdT5jVxe3ijLbmjE1c8YybPkiwMHOvpZPTM=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd chara \
      --bash <($out/bin/chara completions --shell bash) \
      --fish <($out/bin/chara completions --shell fish) \
      --zsh <($out/bin/chara completions --shell zsh)
  '';

  meta = {
    description = "Future of cowsay - Colorful characters saying something";
    homepage = "https://github.com/latipun7/charasay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
    mainProgram = "chara";
  };
})
