{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "angrr";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "angrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pBVbzrTy/IWIo6WlhM1qgowfxSU31awyHcRDHNArBMo=";
  };

  cargoHash = "sha256-DoQIJCs36ZmTxdsDCzquKAeOSIUBbo2V+DTx68FZiu4=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    install -m400 -D ./direnv/angrr.sh $out/share/direnv/lib/angrr.sh
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd angrr \
      --bash <($out/bin/angrr completion bash) \
      --fish <($out/bin/angrr completion fish) \
      --zsh  <($out/bin/angrr completion zsh)
  '';

  passthru = {
    tests = {
      module = nixosTests.angrr;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool for auto Nix GC roots retention";
    homepage = "https://github.com/linyinfeng/angrr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ yinfeng ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "angrr";
  };
})
