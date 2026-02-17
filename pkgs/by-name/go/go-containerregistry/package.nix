{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  bins = [
    "crane"
    "gcrane"
  ];
in

buildGoModule (finalAttrs: {
  pname = "go-containerregistry";
  version = "0.20.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-containerregistry";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UDLKdeQ2Nxf5MCruN4IYNGL0xOp8Em2d+wmXX+R9ow4=";
  };
  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/crane"
    "cmd/gcrane"
  ];

  outputs = [ "out" ] ++ bins;

  ldflags =
    let
      t = "github.com/google/go-containerregistry";
    in
    [
      "-s"
      "-w"
      "-X ${t}/cmd/crane/cmd.Version=v${finalAttrs.version}"
      "-X ${t}/pkg/v1/remote/transport.Version=${finalAttrs.version}"
    ];

  postInstall =
    lib.concatStringsSep "\n" (
      map (bin: ''
        mkdir -p ''$${bin}/bin &&
        mv $out/bin/${bin} ''$${bin}/bin/ &&
        ln -s ''$${bin}/bin/${bin} $out/bin/
      '') bins
    )
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for cmd in crane gcrane; do
        installShellCompletion --cmd "$cmd" \
          --bash <($GOPATH/bin/$cmd completion bash) \
          --fish <($GOPATH/bin/$cmd completion fish) \
          --zsh <($GOPATH/bin/$cmd completion zsh)
      done
    '';

  # NOTE: no tests
  doCheck = false;

  meta = {
    description = "Tools for interacting with remote images and registries including crane and gcrane";
    homepage = "https://github.com/google/go-containerregistry";
    license = lib.licenses.asl20;
    mainProgram = "crane";
    maintainers = with lib.maintainers; [
      yurrriq
      ryan4yin
    ];
  };
})
