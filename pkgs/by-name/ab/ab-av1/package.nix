{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  ffmpeg-headless,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ab-av1";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = "ab-av1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A28si8NepQYD+OCqSYFxOQJWLI1PF8VXojSsfkrCCgY=";
  };

  cargoHash = "sha256-gvXXbRoqqMygme5zpdy2dY0zWVno2x/zulgfwHsCh2g=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    wrapProgram $out/bin/ab-av1 \
      --prefix PATH : ${
        lib.makeBinPath [
          (ffmpeg-headless.override {
            withSvtav1 = true;
            withVmaf = true;
            withOpus = true;
          })
        ]
      }

    installShellCompletion --cmd ab-av1 \
      --bash <($out/bin/ab-av1 print-completions bash) \
      --fish <($out/bin/ab-av1 print-completions fish) \
      --zsh <($out/bin/ab-av1 print-completions zsh)
  '';

  meta = {
    description = "AV1 re-encoding using ffmpeg, svt-av1 & vmaf";
    homepage = "https://github.com/alexheretic/ab-av1";
    changelog = "https://github.com/alexheretic/ab-av1/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chgrv ];
    mainProgram = "ab-av1";
  };
})
