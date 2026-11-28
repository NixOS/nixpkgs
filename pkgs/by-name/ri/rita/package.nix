{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rita";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "activecm";
    repo = "rita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BGVq3JxHOGSMXEK3DoVRDNlWZ4yaf7Qjh/QRECmTFq0=";
  };

  vendorHash = "sha256-7QjrQHkyEYX1WkSuK3u0JVVVeYlAXalXnCsI3rZcJr4=";

  ldflags = [
    "-s"
    "-X=github.com/activecm/rita/v5/config.Version=${finalAttrs.version}"
  ];

  # Almost all tests require a live ClickHouse container via Docker
  doCheck = false;

  meta = {
    description = "Framework for detecting command and control communication through network traffic analysis";
    homepage = "https://github.com/activecm/rita";
    changelog = "https://github.com/activecm/rita/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rita";
  };
})
