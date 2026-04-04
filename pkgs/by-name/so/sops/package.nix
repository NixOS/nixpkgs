{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  makeWrapper,
  runCommand,
  age,
}:

buildGoModule (finalAttrs: {
  pname = "sops";
  version = "3.12.2";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-1VGaS0uhacxjNOP/USmFHlrewkGzRzrV6xamDXY8hgc=";
  };

  vendorHash = "sha256-HgfJMTTWzQ4+59nuy/et3KxQaZEcfrjcWSr/iOOdpb0=";

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion --cmd sops --bash ${./bash_autocomplete}
    installShellCompletion --cmd sops --zsh ${./zsh_autocomplete}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  # wrap sops with age plugins
  passthru.withAgePlugins =
    filter:
    runCommand "sops-${finalAttrs.version}-with-age-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        makeWrapper ${lib.getBin finalAttrs.finalPackage}/bin/sops $out/bin/sops \
          --prefix PATH : "${lib.makeBinPath (filter age.passthru.plugins)}"
      '';

  meta = {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "sops";
    maintainers = with lib.maintainers; [
      Scrumplex
      mic92
      kaynetik
    ];
    license = lib.licenses.mpl20;
  };
})
