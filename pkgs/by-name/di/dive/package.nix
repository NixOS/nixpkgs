{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  btrfs-progs,
  gpgme,
  lvm2,
}:
buildGoModule rec {
  pname = "dive";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    hash = "sha256-kVFXidcvSlYi+aD+3yEPYy1Esm0bl02ioX1DmO0L1Hs=";
  };

  vendorHash = "sha256-9lNtKpfGDVE3U0ZX0QcaCJrqCxoubvWqR26IvSKkImM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    gpgme
    lvm2
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Tool for exploring each layer in a docker image";
    mainProgram = "dive";
    homepage = "https://github.com/wagoodman/dive";
    changelog = "https://github.com/wagoodman/dive/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
