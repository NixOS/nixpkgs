{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-XbA1nyiHG8aTXXcJ4puAMutLXrjgus1fdI0Rv+YHh7k=";
  };

  vendorHash = "sha256-PnFBBRF5RH908wPAKQjyY4DiKYUq31uxNb9qYMwiybs=";

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
