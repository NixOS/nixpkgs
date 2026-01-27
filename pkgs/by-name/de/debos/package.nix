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
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "go-debos";
    repo = "debos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/HeFJX3824enbqcQfzCvnP11ku5/f4+BV+JUBoLdX7w=";
  };

  vendorHash = "sha256-+3PAqCOFtR8HC4uNNxH1cKk/qkD13zuydTsZte1mQ+c=";

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
