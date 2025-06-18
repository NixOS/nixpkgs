{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "bitbucket-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "swisscom";
    repo = "bitbucket-cli";
    rev = "v${version}";
    hash = "sha256-8Qvlv/S5IkRk+2D/Pnb0+FP7ryHh1kSRJCiUjSO0OtI=";
  };

  vendorHash = "sha256-xjCY3Ycz5Ty6jTDHNNUWYp2SP8EPhDiwO7+WJBL3lAQ=";

  # Tests seem to be using Swisscom's live servers.
  doCheck = false;

  meta = {
    description = "Bitbucket Enterprise CLI";
    homepage = "https://github.com/swisscom/bitbucket-cli";
    mainProgram = "bitbucket-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
