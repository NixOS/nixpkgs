{
  lib,
  buildGoModule,
  fetchFromGitHub,
  dpkg,
  pkg-config,
  glib,
  ostree,
  qemu,
  unzip,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "debos";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "go-debos";
    repo = "debos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Xv7r1uyISp1whALtFZWNQgTMH0swd/0+QdRCmXM4DQ=";
  };

  vendorHash = "sha256-FdcmitxGKzkHqFjllDGW24Lr8yrsYDBzuEDRco9CW14=";

  nativeBuildInputs = [
    dpkg
    pkg-config
    unzip
  ];

  buildInputs = [
    glib
    ostree
    qemu
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to create Debian OS images";
    homepage = "https://github.com/go-debos/debos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "debos";
  };
})
