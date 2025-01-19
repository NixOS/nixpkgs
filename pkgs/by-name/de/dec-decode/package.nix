{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dec-decode";
  version = "unstable-2022-12-24";

  src = fetchFromGitHub {
    owner = "sammiq";
    repo = pname;
    rev = "6ee103c";
    hash = "sha256-vOYKVl00oaXwp77pRLqUPnXQT5QuJfqnGGkQVBMq5W0=";
  };

  vendorHash = "sha256-zGWRzw1KUmifIsTudlgoKCR3+K0FLehHRSB3lNX+OWY=";

  meta = {
    description = "Nintendo Wii iso.dec decoder";
    mainProgram = "dec-decode";
    homepage = "https://github.com/sammiq/dec-decode";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
