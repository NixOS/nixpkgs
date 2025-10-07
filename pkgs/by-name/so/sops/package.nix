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
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = final.pname;
    tag = "v${final.version}";
    hash = "sha256-AAnrZvNkBgliHdk1lAoFrJdISNWteFdBUorRycKsptU=";
  };

  vendorHash = "sha256-9bB3MbE03KEaxUp0VvCnNVKUY4zSUoam8h2cDlAz7RY=";

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
