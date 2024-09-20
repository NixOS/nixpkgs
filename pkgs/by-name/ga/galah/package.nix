{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "galah";
  version = "0-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "0x4D31";
    repo = "galah";
    rev = "69346522df6e5849ca808546d40f1ee0a70f56d8";
    hash = "sha256-9Muo08AYtpMmLvpWl2W/WbvyFl8h364BzDbmcJteIAg=";
  };

  vendorHash = "sha256-+I4K5T6fQcS7KJexFGxpjq5QUX9VnopK8i81veeP6Cw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "LLM-powered web honeypot using the OpenAI API";
    homepage = "https://github.com/0x4D31/galah";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "galah";
  };
}
