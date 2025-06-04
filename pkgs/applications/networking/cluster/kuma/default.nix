{
  lib,
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
  version = "2.10.1";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
    hash = "sha256-7vRz2B1aSxpQrV7Om8Zs4o1kJgSVd9rMsOagQZyWMLI=";
  };

  vendorHash = "sha256-1vI61lfs9R9aY1vFQUxXN99zE1SPSfPQ8RxWxykqqp0=";

  # no test files
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals isFull [ coredns ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  subPackages = map (p: "app/" + p) components;

  postInstall =
    lib.concatMapStringsSep "\n" (p: ''
      installShellCompletion --cmd ${p} \
        --bash <($out/bin/${p} completion bash) \
        --fish <($out/bin/${p} completion fish) \
        --zsh <($out/bin/${p} completion zsh)
    '') components
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
    maintainers = with lib.maintainers; [ zbioe ];
  };
}
