{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, kubectl
}:

buildGoModule rec {
  pname = "arkade";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    rev = version;
    sha256 = "sha256-OBcvJ1+VAE7jDeQ/I/9uc0wiU0iibeflRMmb+ulgDtQ=";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "05zdd5c2x4k4myxmgj32md8wq08i543l8q81rabqgyd3r9nwv4lx";

  # Exclude pkg/get: tests downloading of binaries which fail when sandbox=true
  subPackages = [
    "."
    "cmd"
    "pkg/apps"
    "pkg/archive"
    "pkg/config"
    "pkg/env"
    "pkg/helm"
    "pkg/k8s"
    "pkg/types"
  ];

  ldflags = [
    "-s" "-w"
    "-X github.com/alexellis/arkade/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/cmd.Version=${version}"
  ];

  buildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/arkade" \
      --prefix PATH : ${lib.makeBinPath [ kubectl ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
      "armv6l-linux"
    ];
  };
}
