{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "amneziawg-go";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3I0rtTgW4rVjdSLEjdpv0+7k9imSAF56d5ZksJBxRLs=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorHash = "sha256-oqnDK3H+ssgAc1F85OS/qfJRE+LCnfxDy3v7bf4RxUQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Userspace Go implementation of AmneziaWG";
    homepage = "https://github.com/amnezia-vpn/amneziawg-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    mainProgram = "amneziawg-go";
  };
})
