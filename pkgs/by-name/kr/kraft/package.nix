{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  btrfs-progs,
  go_1_24,
  gpgme,
  nix-update-script,
}:

# Current default is version 1.23.6. Requirement is >= 1.24.
buildGoModule.override { go = go_1_24; } rec {
  pname = "kraftkit";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-ANqcE//21zbs2hNS/b7et1TfJB6DxBC9jXQXsmD70Zw=";
  };

  nativeBuildInputs = [
    pkg-config
    go_1_24
  ];

  buildInputs =
    [
      gpgme
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      btrfs-progs
    ];

  vendorHash = "sha256-1nlMiMDBCIFmF58ttFm3I3M5eSTP0qrYyZNmfewXaZk=";

  ldflags = [
    "-s"
    "-w"
    "-X kraftkit.sh/internal/version.version=${version}"
  ];

  subPackages = [ "cmd/kraft" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Build and use highly customized and ultra-lightweight unikernel VMs";
    homepage = "https://github.com/unikraft/kraftkit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      dit7ya
      cloudripper
    ];
    mainProgram = "kraft";
  };
}
