{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-3dI3F1cCeLEOd+zusWUDZWLrVaaKHXzwOL/mF/yPZC8=";
  };

  vendorHash = "sha256-4zciooCUNVLTQ/0tctqV3hExR5vRY5VumHzGtL8xdws=";

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
