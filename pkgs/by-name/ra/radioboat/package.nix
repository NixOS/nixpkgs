{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  mpv,
  makeWrapper,
  installShellFiles,
  nix-update-script,
  testers,
  radioboat,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radioboat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mPktliuWyrXuNzMCdMFZk5Q7lIkRk+y4nX3IBnCc5Mc=";
  };

  cargoHash = "sha256-fRF1FvwtvVJSTCK8DcZib6wMLpo73YtV7j+kjt4nVTo=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd radioboat \
      --bash <($out/bin/radioboat completion bash) \
      --fish <($out/bin/radioboat completion fish) \
      --zsh <($out/bin/radioboat completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = radioboat;
      command = "radioboat --version";
    };
  };

  meta = {
    description = "Terminal web radio client";
    mainProgram = "radioboat";
    homepage = "https://github.com/slashformotion/radioboat";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      zendo
      slashformotion
    ];
  };
})
