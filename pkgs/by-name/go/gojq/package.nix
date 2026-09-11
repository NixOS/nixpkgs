{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gojq";
  version = "0.12.19";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-egaBNHKKzwDwaUN4GT+Xvt11Nz6ojNMSIrXbcEisyI4=";
  };

  vendorHash = "sha256-6UnX9YHh4RGcIFfqaJLxDPxuGQ6KO4UIOryXsoJUjFs=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gojq --zsh _gojq
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  postInstallCheck = ''
    $out/bin/gojq --help > /dev/null
    $out/bin/gojq --raw-output '.values[1]' <<< '{"values":["hello","world"]}' | grep '^world$' > /dev/null
  '';
  doInstallCheck = true;

  meta = {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    changelog = "https://github.com/itchyny/gojq/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "gojq";
  };
})
