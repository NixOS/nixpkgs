{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gojq";
  version = "0.12.18";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9oqyNG8kaM4LmMWOZ2aQqabx97xw6Bt1PgjhVuPU+YE=";
  };

  vendorHash = "sha256-NxhoCbDRduegRcBoZbNi2CB7QRXvqpLv7cAL2mEy9tM=";

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
