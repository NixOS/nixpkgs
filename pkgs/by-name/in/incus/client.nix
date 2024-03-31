{
  lts ? false,
  meta,
  patches,
  src,
  vendorHash,
  version,

  lib,
  buildGoModule,
  installShellFiles,
}:
let
  pname = "incus${lib.optionalString lts "-lts"}-client";
in

buildGoModule {
  inherit
    meta
    patches
    pname
    src
    vendorHash
    version
    ;

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/incus" ];

  postInstall = ''
    installShellCompletion --cmd incus \
      --bash <($out/bin/incus completion bash) \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)
  '';

  # don't run the full incus test suite
  doCheck = false;
}
