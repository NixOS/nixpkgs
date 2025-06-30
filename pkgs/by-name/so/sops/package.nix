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

buildGoModule (final: {
  pname = "sops";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = final.pname;
    tag = "v${final.version}";
    hash = "sha256-IdQnxVBMAQpSAYB2S3D3lSULelFMBpjiBGOxeTgC10I=";
  };

  vendorHash = "sha256-7aHUIERVSxv3YGAMteGbqkAZQXXDVziV0rhUhjwch3U=";

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${final.version}"
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
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  # wrap sops with age plugins
  passthru.withAgePlugins =
    filter:
    runCommand "sops-${final.version}-with-age-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        makeWrapper ${lib.getBin final.finalPackage}/bin/sops $out/bin/sops \
          --prefix PATH : "${lib.makeBinPath (filter age.passthru.plugins)}"
      '';

  meta = {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${final.version}/CHANGELOG.rst";
    mainProgram = "sops";
    maintainers = with lib.maintainers; [
      Scrumplex
      mic92
    ];
    license = lib.licenses.mpl20;
  };
})
