{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-GG5p2sAIameGo6IFt3IBwFuLfVFRbfHjrQrG6Ei9odA=";
  };

  vendorHash = "sha256-VYHBqVFXX7fUuW2UqPOlbRDEfcysYvjSlfm0UJ2mMGM=";

  # Disable all tests that require network access in some form
  checkFlags = let disabledTests = [
    "TestCanCreateTCPConnection"
    "TestCanPerformStartTLS"
    "TestCanPerformTLS"
    "TestChecker_IsConnected"
    "TestConfig_RegisterHandlers"
    "TestEndpoint/domain-expiration"
    "TestEndpoint/endpoint-that-will-time-out-and-hidden-hostname"
    "TestEndpoint/endpoint-that-will-time-out-and-hidden-url"
    "TestGetDomainExpiration"
    "TestIntegrationEvaluateHealth"
    "TestIntegrationQuery"
    "TestOIDCConfig_callbackHandler"
    "TestPing"
  ]; in [
    "-skip=${builtins.concatStringsSep "|" disabledTests}"
  ];

  meta = {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    changelog = "https://github.com/TwiN/gatus/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.linux;
  };
}
