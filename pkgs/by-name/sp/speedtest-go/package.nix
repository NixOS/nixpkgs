{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "speedtest-go";
  version = "1.7.11";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = "speedtest-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ziJOnnbFWHBZ48pcV8DCU10RNKijgedlHUQFdaXg9Qs=";
  };

  vendorHash = "sha256-6oiMuMGDEGueAwlJiqPIok+wetvoHdLuR/lSrerBnYw=";

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
