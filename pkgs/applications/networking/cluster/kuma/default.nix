{ lib
, fetchFromGitHub
, buildGoModule
, coredns
, installShellFiles
, isFull ? false
, enableGateway ? false
, pname ? "kuma"
, components ? lib.optionals isFull [
    "kumactl"
    "kuma-cp"
    "kuma-prometheus-sd"
    "kuma-dp"
  ]
}:

buildGoModule rec {
  inherit pname ;
  version = "1.4.1";
  tags = lib.optionals enableGateway ["gateway"];
  vendorSha256 = "sha256-9v+ti/JTAF4TLZ0uvzFvrB0YBnRD2E0Q6K2yicEX3Zw=";

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
    sha256 = "sha256-zx4rohkv6jm2abtd0I/uQMITkCuhY3StHMKoaTxce0Q=";
  };

  doCheck = false;

  nativeBuildInputs = [installShellFiles] ++ lib.optionals isFull [coredns];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  subPackages = map (p: "app/" + p) components;

  postInstall = lib.concatMapStringsSep "\n" (p: ''
    installShellCompletion --cmd ${p} \
      --bash <($out/bin/${p} completion bash) \
      --fish <($out/bin/${p} completion fish) \
      --zsh <($out/bin/${p} completion zsh)
  '') components + lib.optionalString isFull ''
    ln -sLf ${coredns}/bin/coredns $out/bin
  '';

  ldflags = let
    prefix = "github.com/kumahq/kuma/pkg/version";
  in [
    "-s" "-w"
    "-X ${prefix}.version=${version}"
    "-X ${prefix}.gitTag=${version}"
    "-X ${prefix}.gitCommit=${version}"
    "-X ${prefix}.buildDate=${version}"
  ];

  meta = with lib; {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ zbioe ];
  };
}
