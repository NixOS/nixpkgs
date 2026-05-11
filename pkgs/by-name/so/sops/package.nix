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
  version = "3.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "getsops";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-sJAK7iCVmjGAjQ0CBVsJI7L/GwHB9bvm354Cq3WQI1M=";
  };

  vendorHash = "sha256-aBHZPh5ib2BOxoHQH6q8GD/EJOb2x1OBBePicwoI6Gc=";

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
    ];
    license = lib.licenses.mpl20;
  };
})
