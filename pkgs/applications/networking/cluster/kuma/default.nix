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
  version = "2.13.6";
  tags = lib.optionals enableGateway [ "gateway" ];

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    tag = "v${version}";
    hash = "sha256-oA6yN369Ndkm4+B15RnFXPGRFVFhKwGRunMGHZ1DZKo=";
  };

  vendorHash = "sha256-f8FBx4ODzJHk7CwRCZ7Ot/YUEGrLQVx/a22X1vWj3kQ=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.26.3" "go 1.26.2"
  '';

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
      "-X ${prefix}.gitCommit=v${version}"
      "-X ${prefix}.buildDate=${version}"
    ];

  meta = {
    description = "Service mesh controller";
    homepage = "https://kuma.io/";
    changelog = "https://github.com/kumahq/kuma/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
