{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-puFFby6+e5FDWduETtI5Iflq9E65vJkg2gRdcUxpRKk=";
  };

  vendorHash = "sha256-o1DFHwSpHtbuU8BFcrk18hPRJJkeoPkYnybIz22Blfk=";

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
