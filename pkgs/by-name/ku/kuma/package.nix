{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo127Module,
  coredns,
  installShellFiles,
  isFull ? true,
  enableGateway ? false,
  pname ? "kuma",
  components ? lib.optionals isFull [
    "kumactl"
    "kuma-cp"
    "kuma-dp"
  ],
}:

buildGo127Module rec {
  inherit pname;
  version = "3.0.1";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    tag = "v${version}";
    hash = "sha256-tZGmywuMWBK1LgOmhDalhrBEcd16QpgvM12bzDhtqek=";
  };

  vendorHash = "sha256-RH9ZYy3NVyX7gl7Cyj6K9UuQ1hkebcqL8MnZqMCM1Jw=";

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
      prefix = "github.com/kumahq/kuma/v2/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${prefix}.version=${version}"
      "-X ${prefix}.gitTag=v${version}"
      "-X ${prefix}.gitCommit=${version}"
      "-X ${prefix}.buildDate=${version}"
    ];

  meta = {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
    changelog = "https://github.com/kumahq/kuma/releases/tag/v${version}";
    license = lib.licenses.asl20;
  };
}
