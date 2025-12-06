{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lndir,
  testers,
  regclient,
}:

let
  bins = [
    "regbot"
    "regctl"
    "regsync"
  ];
in

buildGoModule (finalAttrs: {
  pname = "regclient";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-m7gN6Rpj/p726a3yG0dMSOL536N7KTKwiXbckcS67GM=";
  };
  vendorHash = "sha256-uWlZHQ2LKPdKBsct6t8ZPNk3MzrVzpm9+Ny51wYDZZA=";

  outputs = [ "out" ] ++ bins;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/regclient/regclient/internal/version.vcsTag=${finalAttrs.src.tag}"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [
    installShellFiles
    lndir
  ];

  postInstall = lib.concatMapStringsSep "\n" (
    bin:
    ''
      export bin=''$${bin}
      export outputBin=bin

      mkdir -p $bin/bin
      mv $out/bin/${bin} $bin/bin
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd ${bin} \
        --bash <($bin/bin/${bin} completion bash) \
        --fish <($bin/bin/${bin} completion fish) \
        --zsh <($bin/bin/${bin} completion zsh)
    ''
    + ''
      lndir -silent $bin $out

      unset bin outputBin
    ''
  ) bins;

  checkFlags = [
    # touches network
    "-skip=^ExampleNew$"
  ];

  passthru.tests = lib.mergeAttrsList (
    map (bin: {
      "${bin}Version" = testers.testVersion {
        package = regclient;
        command = "${bin} version";
        version = finalAttrs.tag;
      };
    }) bins
  );

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Docker and OCI Registry Client in Go and tooling using those libraries";
    homepage = "https://github.com/regclient/regclient";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.maxbrunet ];
  };
})
