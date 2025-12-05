{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  coredns,
  installShellFiles,
  isFull ? false,
  enableGateway ? false,
  pname ? "kuma",
  components ? lib.optionals isFull [
    "kumactl"
    "kuma-cp"
    "kuma-dp"
  ],
}:

buildGoModule rec {
  inherit pname;
  version = "2.12.1";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    tag = version;
    hash = "sha256-9s89fiBFIP6azB1SDCZkTlQWAQ2C6htQXRMvyWrNch0=";
  };

  vendorHash = "sha256-KgZYKopW+FOdwBIGxa2RLiEbefZ/1vAhcsWtcYhgdFs=";

  # no test files
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals isFull [ coredns ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  subPackages = map (p: "app/" + p) components;

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
      lib.concatMapStringsSep "\n" (p: ''
        installShellCompletion --cmd ${p} \
          --bash <($out/bin/${p} completion bash) \
          --fish <($out/bin/${p} completion fish) \
          --zsh <($out/bin/${p} completion zsh)
      '') components
    )
    + lib.optionalString isFull ''
      ln -sLf ${coredns}/bin/coredns $out/bin
    '';

  ldflags =
    let
      prefix = "github.com/kumahq/kuma/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${prefix}.version=${version}"
      "-X ${prefix}.gitTag=${version}"
      "-X ${prefix}.gitCommit=${version}"
      "-X ${prefix}.buildDate=${version}"
    ];

  meta = {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
    changelog = "https://github.com/kumahq/kuma/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
