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
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "go-debos";
    repo = "debos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eO+H5zf4oYk7MhgnuDyG3L8vjD79orS7SiSXOXdg6+0=";
  };

  vendorHash = "sha256-E6BhKCwhaEN0qkJ8hLXb/rUoceypMGN3cg5qKNoNAa8=";

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
