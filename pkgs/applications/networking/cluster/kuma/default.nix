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
    "kuma-dp"
  ]
}:

buildGoModule rec {
  inherit pname;
  version = "2.6.3";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
    hash = "sha256-m/mCnX/VFUPd3+DY+7znes55myIiJ8+T51NPcgWOiZc=";
  };

  vendorHash = "sha256-otrm8avM35/8WqjSO8V8hMAzsh51unyrMVDv4321xoY=";

  # no test files
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals isFull [ coredns ];

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
    changelog = "https://github.com/kumahq/kuma/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ zbioe ];
  };
}
