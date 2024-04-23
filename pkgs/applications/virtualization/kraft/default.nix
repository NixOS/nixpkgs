{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-Ob02OjqQGV60TE1CBe/Hr/WWiPNQ/33T1vPYPmJBr/4=";
  };

  vendorHash = "sha256-XYYGr/mJYQuiDJFRrr8GlQbotM+Sb8xaBiARjZ/UyIs=";

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
