{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fanbox-dl";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Cv4m0zVXqsp+OyYh3viXrJpoxOuQdGIWt1MNwxwwt7A=";
  };

  vendorHash = "sha256-926PY/byA23wkugkdHLjiGmRgezzEiy4wiGpIXlWsNM=";

  # pings websites during testing
  doCheck = false;

  meta = {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.moni ];
  };
})
