{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gojq";
  version = "0.12.20";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Hg1q7xfzRzscehGkm4+N8j6ssaCrGuG9GbB2SlOhXg8=";
  };

  vendorHash = "sha256-/Grt8GUozoYu6GiVzHweyNmfnEmMoI+MrcSBw4hd5oI=";

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
