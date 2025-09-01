{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "matcha-rss-digest";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "matcha";
    rev = "v${version}";
    hash = "sha256-Zs6Och5CsqN2mpnCLgV1VkH4+CV1fklfP20A22rE5y0=";
  };

  vendorHash = "sha256-CURFy92K4aNF9xC8ik6RDadRAvlw8p3Xc+gWE2un6cc=";

  meta = with lib; {
    homepage = "https://github.com/piqoni/matcha";
    description = "Daily digest generator from a list of RSS feeds";
    license = licenses.mit;
    mainProgram = "matcha";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
