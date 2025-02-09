{ buildGoModule
, fetchFromGitHub
, docker
, lib
}:

buildGoModule rec {
  pname = "docker-sbom";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "sbom-cli-plugin";
    rev = "tags/v${version}";
    hash = "sha256-i3gIogHb0oW/VDuZUo6LGBmvqs/XfMXjpvTTYeGCK7Q=";
  };

  patches = [
    # Disable tests that require a docker daemon to be running
    # in the sandbox
    ./sbom-disable-tests.patch
  ];

  vendorHash = "sha256-XPPVAdY2NaasZ9bkf24VWWk3X5pjnryvsErYIWkeekc=";

  nativeBuildInputs = [ docker ];

  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/sbom-cli-plugin $out/libexec/docker/cli-plugins/docker-sbom

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-sbom $out/bin/docker-sbom
    runHook postInstall
  '';

  meta = with lib; {
    description = "Plugin for Docker CLI to support SBOM creation using Syft";
    homepage = "https://github.com/docker/sbom-cli-plugin";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof ];
  };
}
