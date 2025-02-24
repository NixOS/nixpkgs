{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
}:

buildGoModule rec {
  pname = "ratchet";
  version = "0.10.2";

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
    rev = "ee93c849418d0b9316703bb349055a4078ad205e";
    hash = "sha256-pVpZB8WWGgFbu0iK6gM2lEaXN4IqDJ1lMtVnUfcE4MQ=";
  };

  proxyVendor = true;

  vendorHash = "sha256-KKHlegmvpmmUZGoiEawgSUwOPQEfTjfzTYvere1YAv4=";

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

    install -Dm755 "$GOPATH/bin/ratchet" -T $out/bin/ratchet

    runHook postInstall
  '';

  passthru.tests.execution = callPackage ./tests.nix { };

  meta = {
    description = "Tool for securing CI/CD workflows with version pinning";
    mainProgram = "ratchet";
    downloadPage = "https://github.com/sethvargo/ratchet";
    homepage = "https://github.com/sethvargo/ratchet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cameronraysmith
      ryanccn
    ];
  };
}
