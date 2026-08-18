{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  runitor,
}:

buildGoModule (finalAttrs: {
  pname = "runitor";
  version = "1.4.1";
  vendorHash = "sha256-SYYAAtuWt/mTmZPBilYxf2uZ6OcgeTnobYiye47i8mI=";

  src = fetchFromGitHub {
    owner = "bdd";
    repo = "runitor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-y4wIfal8aiVD5ZoRF6GnYUGRssBLMOPSWa40+3OU4y0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = runitor;
    command = "runitor -version";
    version = "v${finalAttrs.version}";
  };

  # Unit tests require binding to local addresses for listening sockets.
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://bdd.fi/x/runitor";
    description = "Command runner with healthchecks.io integration";
    longDescription = ''
      Runitor runs the supplied command, captures its output, and based on its exit
      code reports successful or failed execution to https://healthchecks.io or your
      private instance.

      Healthchecks.io is a web service for monitoring periodic tasks. It's like a
      dead man's switch for your cron jobs. You get alerted if they don't run on time
      or terminate with a failure.
    '';
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ bdd ];
    mainProgram = "runitor";
  };
})
