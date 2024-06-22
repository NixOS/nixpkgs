{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-OC0buWQlb9sb4SXokOpeUHcQKMLeYN3ZVQGXtoiIMVM=";
  };

  vendorHash = "sha256-qsdFfAgA72T3iOZRJdteo6T92lGi3yzcKcxj837YnG4=";

  # pings websites during testing
  doCheck = false;

  meta = with lib; {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = licenses.mit;
    maintainers = [ maintainers.moni ];
  };
}
