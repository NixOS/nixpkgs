{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  buildPackages,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcat-unwrapped";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c90jBmFVf5WDww5pxnEdlvrwyISlrExXT1GVr436Nqs=";
  };

  cargoHash = "sha256-K7K1miS2eYKt6R8NuO0qFhdRyXL3Dj7DBr8inrw7j3c=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      mcat =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.mcat-unwrapped;
    in
    ''
      installShellCompletion --cmd mcat \
        --bash <(${mcat}/bin/mcat --generate bash) \
        --fish <(${mcat}/bin/mcat --generate fish) \
        --zsh <(${mcat}/bin/mcat --generate zsh)
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "cat command for documents / images / videos and more!";
    homepage = "https://github.com/Skardyy/mcat";
    changelog = "https://github.com/Skardyy/mcat/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mcat";
    maintainers = with lib.maintainers; [
      louis-thevenet
    ];
  };
})
