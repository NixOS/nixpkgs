{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-2fxptsETjWyQxQv/VDx2A5UMZ3oLgC298YY/To3qaqk=";
  };

  vendorHash = "sha256-l/mgjCqRzidJ1QxH8bKGa7ZnRZVOqkuNifgEyFVU7fA=";

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
