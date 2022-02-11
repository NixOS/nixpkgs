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
  version = "1.4.0";
  tags = lib.optionals enableGateway ["gateway"];
  vendorSha256 = "19rd450gmc51gmwa13991lbkva7r80d2camikkxmmgywyhrd06sf";

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
    sha256 = "0agib3w5s270n5rhg54m3p4f21s5fhdrhaks374j7l21njs7xhqb";
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
