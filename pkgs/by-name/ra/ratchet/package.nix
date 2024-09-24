{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
}:
buildGoModule rec {
  pname = "ratchet";
  version = "0.9.2";

  # ratchet uses the git sha-1 in the version string, e.g.
  #
  # $ ./ratchet --version
  # ratchet 0.9.2 (d57cc1a53c022d3f87c4820bc6b64384a06c8a07, darwin/arm64)
  #
  # so we need to either hard-code the sha-1 corresponding to the version tag
  # head or retain the git metadata folder and extract it using the git cli.
  # We currently hard-code it.
  src = fetchFromGitHub {
    owner = "sethvargo";
    repo = "ratchet";
    rev = "d57cc1a53c022d3f87c4820bc6b64384a06c8a07";
    hash = "sha256-gQ98uD9oPUsECsduv/lqGdYNmtHetU49ETfWCE8ft8U=";
  };

  proxyVendor = true;
  vendorHash = "sha256-J7LijbhpKDIfTcQMgk2x5FVaYG7Kgkba/1aSTmgs5yw=";

  subPackages = [ "." ];

  ldflags =
    let
      package_url = "github.com/sethvargo/ratchet";
    in
    [
      "-s"
      "-w"
      "-X ${package_url}/internal/version.name=ratchet"
      "-X ${package_url}/internal/version.version=${version}"
      "-X ${package_url}/internal/version.commit=${src.rev}"
    ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ratchet --version 2>&1 | grep ${version};
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/ratchet" -T $out/bin/ratchet
    runHook postInstall
  '';

  passthru.tests = {
    execution = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Tool for securing CI/CD workflows with version pinning";
    mainProgram = "ratchet";
    downloadPage = "https://github.com/sethvargo/ratchet";
    homepage = "https://github.com/sethvargo/ratchet";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cameronraysmith
      ryanccn
    ];
  };
}
