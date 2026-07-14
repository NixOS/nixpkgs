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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Skardyy";
    repo = "mcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7QjnbdxUFeRDkIGnAcY2Wf8fLKuj1RuVbu0SUebOc5A=";
  };

  cargoHash = "sha256-JnSycAz/jFs9JgA3tqYZn64yNK0bv5SXEYyUOXjC4ug=";

  nativeBuildInputs = [
    installShellFiles
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
