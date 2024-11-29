{
  buildGoModule,
  docker-credential-gcr,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule rec {
  pname = "docker-credential-gcr";
  version = "2.1.26";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    rev = "refs/tags/v${version}";
    hash = "sha256-4sgUeEXBfP0qaR92ZulqAf1ObQBDbSjEHqhAqa0EV2Q=";
  };

  postPatch = ''
    rm -rf ./test
  '';

  vendorHash = "sha256-YcBDurQjGhjds3CB63gTjsPbsvlHJnGxWbsFrx3vCy4=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/docker-credential-gcr/v2/config.Version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = docker-credential-gcr;
      command = "docker-credential-gcr version";
    };
    updateScript = nix-update-script { };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = "https://github.com/GoogleCloudPlatform/docker-credential-gcr";
    changelog = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ suvash anthonyroussel ];
    mainProgram = "docker-credential-gcr";
  };
}
