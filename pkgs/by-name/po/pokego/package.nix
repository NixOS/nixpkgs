{
  lib,
  stdenv,
  buildPackages,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "pokego";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rubiin";
    repo = "pokego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0zlOyEsgdFmWzQg8/O9VYkM5kZM3c63DHH9rqhLhG70=";
  };

  vendorHash = "sha256-7K17JaXFsjf163g5PXCb5ng2gYdotnZ2IDKk8KFjNj0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/pokego"
        else
          lib.getExe buildPackages.pokego;
    in
    ''
      installShellCompletion --cmd pokego \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display Pokémon sprites in color directly in your terminal";
    homepage = "https://github.com/rubiin/pokego";
    license = lib.licenses.gpl3Only;
    mainProgram = "pokego";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yvnth ];
  };
})
