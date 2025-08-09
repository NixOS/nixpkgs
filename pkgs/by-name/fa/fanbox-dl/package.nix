{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-zccTxLEbKAErgVVaL+CPYD9GCPCAjGYnOiyGBGDmSzg=";
  };

  vendorHash = "sha256-BZebo50HEKIk1z0LJg8kE1adovyAk67L6jsiaNcpeDY=";

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
