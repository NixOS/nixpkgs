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
  version = "2.11.1";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    tag = version;
    hash = "sha256-OOuGPVDuCwUhKr2K1sXs4hMWlOqGkXuBXj20ffwhCco=";
  };

  vendorHash = "sha256-hq+n9nTSf7LDMvlttTmk59pZQaJJIRlqwOSBtMJKPfc=";

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
