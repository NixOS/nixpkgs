{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-secdump";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jfjallid";
    repo = "go-secdump";
    tag = version;
    hash = "sha256-v/IqOjohlGs6MQX2BevboysqW6Lzz0NupDH6sb1TG7Q=";
  };

  vendorHash = "sha256-H9oFvnyigjwEs24XGGH5mtDMMCo846y0nFIlsrbvLMk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to remotely dump secrets from the Windows registry";
    homepage = "https://github.com/jfjallid/go-secdump";
    changelog = "https://github.com/jfjallid/go-secdump/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "go-secdump";
    platforms = lib.platforms.linux;
  };
}
