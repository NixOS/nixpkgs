{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "speedtest-go";
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = "speedtest-go";
    tag = "v${version}";
    hash = "sha256-w0gIyeoQP+MfA9Q2CD7+laABmSrJ9u836E+UIhJeWdk=";
  };

  vendorHash = "sha256-2z241HQOckNFvQWkxfjVVmmdFW4XevQBLj8huxYAheg=";

  excludedPackages = [ "example" ];

  # test suite requires network
  doCheck = false;

  meta = {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aleksana
      luftmensch-luftmensch
    ];
    mainProgram = "speedtest-go";
  };
}
