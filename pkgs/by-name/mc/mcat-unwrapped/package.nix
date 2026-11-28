{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  aws-lc,
  buildPackages,
  nix-update-script,
  oniguruma,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcat-unwrapped";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AwMzEKZ/e5Sbzmv7DBmBmGGy6xOm0lu8aLzTHNh60t8=";
  };

  cargoHash = "sha256-j8aNKU8iY4fmi+IUvzk1hPkxSFhCL9Iz4alRZo74rKk=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    aws-lc
    oniguruma
  ];

  checkFlags = [
    # Requires network access: the test embeds a remote URL in the SVG.
    "--skip=stdin_svg_output_is_image"
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
    description = "cat command for documents / images / videos and more";
    homepage = "https://github.com/Skardyy/mcat";
    changelog = "https://github.com/Skardyy/mcat/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mcat";
    maintainers = with lib.maintainers; [
      louis-thevenet
    ];
  };
})
