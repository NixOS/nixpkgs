{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.4.3";
in
buildGoModule {
  pname = "lightningstream";
  inherit version;

  src = fetchFromGitHub {
    owner = "PowerDNS";
    repo = "lightningstream";
    tag = "v${version}";
    hash = "sha256-gnLmqm35HHpQlglKjw57NBMs8jMAHDieWlnE3OAQR4I=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-wkLoaR46l+jCm3TJDflcuI2hDvluoH2o5lLIqtrVRqo=";

  nativeBuildInputs = [ installShellFiles ];

  # Install shell completions so long as we can run the binary to do so. This means that
  # when cross compiling we may not be able to generate shell completions.
  # See https://github.com/NixOS/nixpkgs/issues/308283
  #
  # Dummy config file is currently required to generate completions. This may be fixed
  # upstream; see https://github.com/PowerDNS/lightningstream/issues/85
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    cat <<END > lightningstream.yaml
    lmdbs:
      dummy:
        path: dummy
    END

    installShellCompletion \
      --cmd lightningstream \
      --bash <($out/bin/lightningstream completion bash) \
      --fish <($out/bin/lightningstream completion fish) \
      --zsh <($out/bin/lightningstream completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "LMDB sync via S3 buckets";
    mainProgram = "lightningstream";
    license = lib.licenses.mit;
    homepage = "https://doc.powerdns.com/lightningstream/latest/index.html";
    maintainers = with lib.maintainers; [ samw ];
  };
}
