{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-4T108ZMM10evGricLj8S+XYw3NXfUI68KlcraWA+nd0=";
  };

  vendorHash = "sha256-qu0GQdjaYXj932KKBphP4CQWsAOssI4+42tPAD3iqik=";

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
