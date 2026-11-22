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
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-LYcaNj8Q7//KwM7/1ZBPbeqIKYWJKX26B2ZbMl67Q/0=";
  };
  vendorHash = "sha256-GwxnXYCIunp8RS1H55mbYZ/WnsDSFCEUWUowEHFedMM=";

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
      local bin=''$${bin}
      local outputBin=bin

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
    ''
  ) bins;

  checkFlags =
    let
      skip = [
        # touch network
        "^ExampleNew$"
        "^TestIsLocal/regclient\\.org$"
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        # The Nix sandbox does not have the /etc/nsswitch.conf file (`hosts: files dns`),
        # so Go defaults to a DNS lookup instead of using the /etc/hosts file.
        "^TestIsLocal/localhost\\.$"
      ];
    in
    [
      "-skip=${builtins.concatStringsSep "|" skip}"
    ];

  passthru.tests = lib.mergeAttrsList (
    map (bin: {
      "${bin}Version" = testers.testVersion {
        package = regclient;
        command = "${bin} version";
        version = finalAttrs.src.tag;
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
