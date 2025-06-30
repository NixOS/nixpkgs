{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  version = "1.7.18";
  pname = "ossutil";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "ossutil";
    tag = "v${version}";
    hash = "sha256-M7Jh3rmWdUlsvj+P0UKazjQoe0zLDro882f/l8wFZGQ=";
  };

  vendorHash = "sha256-4a/bNH47sxxwgYYQhHTqyXddJit3VbeM49/4IEfjWsY=";

  # don't run tests as they require secret access keys that only travis has
  doCheck = false;

  meta = {
    description = "User friendly command line tool to access Alibaba Cloud OSS";
    homepage = "https://github.com/aliyun/ossutil";
    changelog = "https://github.com/aliyun/ossutil/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
    mainProgram = "ossutil";
  };
}
