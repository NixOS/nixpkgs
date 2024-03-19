{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-kuI1RSipPj7e8tsnThAEkL3bpmgAEKSQthubfjtklp0=";
  };

  vendorHash = "sha256-BPpUBGWzW4jkUgy/2oqvqXBNLmglUVTFA9XuGhUE1zo=";

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
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "kraft";
    broken = stdenv.isDarwin; # > machine/platform/iterator_v1alpha1.go:32:34: undefined: hostSupportedStrategies
  };
}
