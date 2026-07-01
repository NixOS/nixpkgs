{
  lib,
  buildGithubBinary,
  testers,
  fakecloud,
}:

buildGithubBinary {
  pname = "fakecloud";
  owner = "faiscadev";
  repo = "fakecloud";
  sourcesJson = ./sources.json;

  passthru.tests.version = testers.testVersion {
    package = fakecloud;
    command = "fakecloud --version";
  };

  meta = {
    description = "Free, open-source AWS emulator (LocalStack alternative)";
    homepage = "https://github.com/faiscadev/fakecloud";
    downloadPage = "https://github.com/faiscadev/fakecloud/releases";
    license = lib.licenses.agpl3Only;
    mainProgram = "fakecloud";
    maintainers = with lib.maintainers; [ kubukoz ];
  };
}
