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
  version = "2.1.30";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    tag = "v${version}";
    hash = "sha256-ZHQLZLw5Qe+60POSxfUZ5nh9punLXHzlXbjrUVR9MKU=";
  };

  postPatch = ''
    rm -rf ./test
  '';

  vendorHash = "sha256-eQ9ZsJqW+FF3XHrqaDm254/vdLxR1Mw5wt+TkWqtXBg=";

  env.CGO_ENABLED = 0;

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

  meta = {
    description = "Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = "https://github.com/GoogleCloudPlatform/docker-credential-gcr";
    changelog = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      suvash
      anthonyroussel
    ];
    mainProgram = "docker-credential-gcr";
  };
}
