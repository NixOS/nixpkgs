{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "matcha-rss-digest";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "matcha";
    rev = "v${version}";
    hash = "sha256-AhXr9T2pvCuTTSU8vHhHELyNiU5EC4KR0fpOGrY02Zo=";
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
