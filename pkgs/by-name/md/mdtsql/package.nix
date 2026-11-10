{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "mdtsql";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "mdtsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fmv8wJfeJ8Lz6Z5OxggrudUvyJaA+22tCs0x2Dvz+Bw=";
  };

  vendorHash = "sha256-/FpbKpxTYiwWVDRxBn3GmPEhna/a+t4CuVq/bZmsb9w=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd mdtsql \
        --bash <(${emulator} $out/bin/mdtsql completion bash) \
        --fish <(${emulator} $out/bin/mdtsql completion fish) \
        --zsh <(${emulator} $out/bin/mdtsql completion zsh)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Execute SQL to markdown table and convert to other format";
    homepage = "https://github.com/noborus/mdtsql";
    changelog = "https://github.com/noborus/mdtsql/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "mdtsql";
  };
})
