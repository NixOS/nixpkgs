{
  buildGoModule,
  docker-credential-gcr,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "docker-credential-gcr";
  version = "2.1.31";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DAqMdVayRRf8MqcE+Vfm3Inh7ja7CjMaHCuvg7/AcUA=";
  };

  postPatch = ''
    rm -rf ./test
  '';

  vendorHash = "sha256-6NLem27nG6SMxxoIWOg5xLyCo8ZDb8kGPSX3TKWi/N4=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/docker-credential-gcr/v2/config.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      suvash
      anthonyroussel
    ];
    mainProgram = "docker-credential-gcr";
  };
})
