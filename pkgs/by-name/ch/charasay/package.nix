{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "charasay";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = "charasay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VkDOdZt0Z/kuBwFm5utXYsxT59a1uapU9ouzB1ymmXs=";
  };

  cargoHash = "sha256-6AczT5VvOryOlcOMNFxcHqy8K1sm4tbhb6+LsCNHW14=";

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
