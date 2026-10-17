{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

let
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-3DCvWaiGLw9OSs/b9za1jgrPDo2Txw5b5h46ElTMEks=";
  };

in
buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-NsOkQwMH/AANUBReXmGR0fFQAtosA9iSla5JXyhrPYE=";
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

  meta = {
    description = "CLI for managing resources in InfluxDB v2";
    license = lib.licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = [ ];
    mainProgram = "influx";
  };
}
