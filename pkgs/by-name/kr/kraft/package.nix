{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, btrfs-progs
, gpgme
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-4+3yMx/Vf4aZKC5GRhnAeH4oaJ0Rbz8oXptMtPV+5tA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gpgme
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
  ];

  vendorHash = "sha256-uyoIlNhgL684f+3+I4CFc+iuMRdI5WAUr7dWr0Bt6bA=";

  ldflags = [
    "-s"
    "-w"
    "-X kraftkit.sh/internal/version.version=${version}"
  ];

  subPackages = [ "cmd/kraft" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "^v([0-9.]+)" ];
    };
  };

  meta = {
    description = "Build and use highly customized and ultra-lightweight unikernel VMs";
    homepage = "https://github.com/unikraft/kraftkit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dit7ya cloudripper ];
    mainProgram = "kraft";
  };
}
