{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  asciidoctor,
  installShellFiles,
  git,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "git-lfs";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "refs/tags/v${version}";
    hash = "sha256-PpNdbvtDAZDT43yyEkUvnhfUTAMM+mYImb3dVbAVPic=";
  };

  vendorHash = "sha256-JT0r/hs7ZRtsYh4aXy+v8BjwiLvRJ10e4yRirqmWVW0=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major version}/config.Vendor=${version}"
  ];

  subPackages = [ "." ];

  preBuild = ''
    GOARCH= go generate ./commands
  '';

  postBuild = ''
    make man
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    unset subPackages
  '';

  postInstall =
    ''
      installManPage man/man*/*
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd git-lfs \
        --bash <($out/bin/git-lfs completion bash) \
        --fish <($out/bin/git-lfs completion fish) \
        --zsh <($out/bin/git-lfs completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Git extension for versioning large files";
    homepage = "https://git-lfs.github.com/";
    changelog = "https://github.com/git-lfs/git-lfs/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
    mainProgram = "git-lfs";
  };
}
