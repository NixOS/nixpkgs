{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fanbox-dl";
  version = "0.28.3";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lHgfAzjlZsQPqiTr20A4hPBQ6cAR5uUiTFdNAkCG2JY=";
  };

  vendorHash = "sha256-oRp2w3KYEPfKr+gWjDzTgvjzzoxOuV8Y/gm+TLzNSpc=";

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
