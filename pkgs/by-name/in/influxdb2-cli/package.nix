{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

let
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    tag = "v${version}";
    hash = "sha256-4bXA7d3DXiUQNBNEYMK+6RzlsKwAjl9ju6qHTL4qP8E=";
  };

in
buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-SH9QYuk5i3n3E2HaukJ6X75vQYQHZag+DeB4aIYHTPI=";
  subPackages = [ "cmd/influx" ];

  ldflags = [
    "-X main.commit=v${version}"
    "-X main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd influx \
      --bash <($out/bin/influx completion bash) \
      --zsh  <($out/bin/influx completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI for managing resources in InfluxDB v2";
    license = lib.licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "influx";
  };
}
