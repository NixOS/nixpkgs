{ buildGoModule
, fetchFromGitHub
, lib
}: buildGoModule rec {
  pname = "ratchet";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sethvargo";
    repo = "ratchet";
    rev = "v${version}";
    hash = "sha256-iK5N0PvPW/55fU7H891wNWls5eJ30yH/sAf8gvzRygI=";
  };

  vendorHash = "sha256-0uaVd57Y5O4cF09uhk4o/P11d6xXNuIyptux0LSWzWE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sethvargo/ratchet/internal/version.name=ratchet"
    "-X=github.com/sethvargo/ratchet/internal/version.version=${version}"
    "-X=github.com/sethvargo/ratchet/internal/version.commit=${src.rev}"
  ];

  checkFlags =
    let
      skippedTests = [
        "TestResolve" # requires network access
        "TestLatestVersion" # requires network access
      ];
    in
    [ "-skip" (lib.concatStringsSep "|" skippedTests) ];

  meta = with lib; {
    description = "A tool for securing CI/CD workflows with version pinning";
    homepage = "https://github.com/sethvargo/ratchet";
    license = licenses.asl20;
    maintainers = with maintainers; [ ryanccn ];
  };
}
