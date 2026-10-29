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

buildGo127Module (finalAttrs: {
  inherit pname;
  version = "2.14.5";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vMoCH/lGqJBmzDzAc0S5K/ubxeiWC1PVlQ0q2XLO5FA=";
  };

  vendorHash = "sha256-RdJ1eLlYSaKrbVguAWu/tXjExIbNlBWKjSKfheegxsk=";

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
      "-X ${prefix}.version=${finalAttrs.version}"
      "-X ${prefix}.gitTag=v${finalAttrs.version}"
      "-X ${prefix}.gitCommit=${finalAttrs.version}"
      "-X ${prefix}.buildDate=${finalAttrs.version}"
    ];

  meta = {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
    changelog = "https://github.com/kumahq/kuma/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
  };
})
