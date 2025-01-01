{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go9p";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "knusbaum";
    repo = "go9p";
    rev = "refs/tags/v${version}";
    hash = "sha256-dqaj92LwHu5VRLLEvrUTFL9i61jG2qCARWBDMt9tGH8=";
  };

  vendorHash = "sha256-HupMxf8CXPhsnsQEnO1KsIJjY3l2jRJopQ2nVYhoYEE=";

  meta = {
    description = "Implementation of the 9p2000 protocol in Go";
    homepage = "https://github.com/knusbaum/go9p";
    license = lib.licenses.mit;
    mainProgram = "mount9p";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
