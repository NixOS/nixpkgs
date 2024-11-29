{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  nixosTests,
  testers,
  thanos,
}:

buildGoModule rec {
  pname = "thanos";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    rev = "refs/tags/v${version}";
    hash = "sha256-Zcc860kQkVP1DPyadBoalhcvwh5HF9CgQyjzWRdeXt0=";
  };

  vendorHash = "sha256-d+jHGmCfx9Ffm5pajm1RvKnMea99JswL0I8nmILXN50=";

  subPackages = "cmd/thanos";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) thanos;
      version = testers.testVersion {
        command = "thanos --version";
        package = thanos;
      };
    };
  };

  meta = with lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    changelog = "https://github.com/thanos-io/thanos/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "thanos";
    maintainers = with maintainers; [
      basvandijk
      anthonyroussel
    ];
  };
}
