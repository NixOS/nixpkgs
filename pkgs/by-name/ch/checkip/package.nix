{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.47.5";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iAMSNz5TDSId0gBm982hFkM+JR4naEREXKS7mi6z5dw=";
  };

  vendorHash = "sha256-awqaDEdWILm8RcQ8hrtJFMTJQA5TzGZhiBTMfexmtA0=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "checkip";
  };
}
