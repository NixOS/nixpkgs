{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "ebuse";
  version = "0-unstable-2024-12-02";

  src = fetchFromGitHub {
    owner = "ebroder";
    repo = "ebuse";
    rev = "7069d850c8f3925956965ee1a8e3e7b80582c76e";
    hash = "sha256-utBnNuSuwxY5myE9kW1j2O7PFypmZPWPnzd9MeKVT4g=";
  };

  vendorHash = "sha256-svAuNUCLCnD7HiQkszrdG2QA9yTujTD49FArO8h+O9g=";

  # needed because of #506926
  proxyVendor = true;

  tags = [
    # the application doesn't use gonbdserver's ceph support; disabling it makes the build much more portable / small
    # https://github.com/abligh/gonbdserver/blob/9abaa2fed84fea02e090dbdd16be7bd20162e8b6/nbd/rbd.go#L3-L7
    "noceph"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Access an EBS snapshot directly through NBD";
    homepage = "https://github.com/ebroder/ebuse";
    license = lib.licenses.mit;
    mainProgram = "ebuse";
    maintainers = with lib.maintainers; [ mildsunrise ];
  };
}
