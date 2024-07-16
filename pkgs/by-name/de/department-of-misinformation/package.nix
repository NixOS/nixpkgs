{
  buildDenoApplication,
  lib,
  fetchFromGitHub,
}:
buildDenoApplication {
  pname = "department-of-misinformation";
  version = "0unstable";

  src = fetchFromGitHub {
    owner = "zebreus";
    repo = "department-of-misinformation";
    rev = "a6f2c780d9b2cd0f6dae01ee769d151a1417ee03";
    hash = "sha256-UBKSMchw6uE3fEuduiilC3nY0xPQqU/jfnOH1jiWO7E=";
  };
  mainScript = "server.ts";
  denoDepsHash = "sha256-KaZWHX7MNVaGwMt/ubr+YObeXkUq8C7rxA5KA/YKW3Y=";
  compile = true;
  runtimeFlags = [
    "--allow-read"
    "--allow-env"
    "--allow-net"
    "--allow-write"
  ];

  meta = with lib; {
    description = "Experimental activitypub server where infra can post status updates";
    homepage = "https://github.com/zebreus/department-of-misinformation";
    license = licenses.mit;
    maintainers = [ maintainers.zebreus ];
  };
}
