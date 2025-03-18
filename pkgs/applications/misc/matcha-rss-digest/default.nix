{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matcha-rss-digest";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "matcha";
    rev = "v${version}";
    hash = "sha256-aW/a1rfq/pjRpJzoEfuj0JMnyFwQKPL1+Wxvh7wVbho=";
  };

  vendorHash = "sha256-bwl4/4yYm8TC3D+FgyXzhQg8SdNHyXQM9YCn8p8+DF0=";

  meta = with lib; {
    homepage = "https://github.com/piqoni/matcha";
    description = "Daily digest generator from a list of RSS feeds";
    license = licenses.mit;
    mainProgram = "matcha";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
