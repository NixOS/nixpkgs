{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "galer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "galer";
    rev = "refs/tags/v${version}";
    hash = "sha256-/VvN6LjK+V8E9XYarRUI/TPGitMM0a3g1lfdYhV1yP8=";
  };

  vendorHash = "sha256-WDOwUjU6AP/8QvqiKTEY6wsMBZQFWn/LGWr8nfqDF+8=";

  meta = with lib; {
    description = "Tool to fetch URLs from HTML attributes";
    homepage = "https://github.com/dwisiswant0/galer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "galer";
  };
}
