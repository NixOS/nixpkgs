{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "speedtest-go";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = "speedtest-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ItZypVHoqs12wR21GNIat4baRh2RIYuMBQiqQGoEJ78=";
  };

  vendorHash = "sha256-n4cF6P/eeQlPd5I6r79XtQnmRWTDvQ/nMEs791D7kn0=";

  excludedPackages = [ "example" ];

  # test suite requires network
  doCheck = false;

  meta = {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aleksana
      luftmensch-luftmensch
    ];
    mainProgram = "speedtest-go";
  };
})
