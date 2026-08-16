{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildGoModule,
  testers,
  restman,
}:

buildGoModule (finalAttrs: {
  pname = "restman";
  version = "0.4.9";

  src = fetchFromGitHub {
    repo = "restman";
    owner = "jackMort";
    rev = "v${finalAttrs.version}";
    hash = "sha256-advp7w9SbMKcuvQhR7pF95VV4J6hUl8rV+9Uu4EaGpc=";
  };

  patches = [
    (fetchpatch {
      # fix for tests committed shortly after 0.4.9
      url = "https://github.com/jackMort/Restman/commit/2d5edd4e4faa0499bf93741fed250f8f13efa9c3.patch";
      hash = "sha256-Mv7+eAKczR4YZDdevK60I1WZrmEumqsXhXMQVwu1zLo=";
    })
  ];

  vendorHash = "sha256-+qjJhDQvZi+SstE2uo+2hsoG2MTRdI6d79Vga3/7gTY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  passthru.tests = {
    version = testers.testVersion {
      package = restman;
      version = "restman version ${finalAttrs.version}";
      command = "restman --version";
    };
  };

  meta = {
    description = "CLI for streamlined RESTful API testing and management";
    homepage = "https://github.com/jackMort/Restman";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "restman";
  };
})
