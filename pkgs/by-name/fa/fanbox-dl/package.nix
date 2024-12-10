{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-JARIY6z912XDvZ6JviLMP8OZLOIzUPLuJtWGpKcqwvY=";
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
