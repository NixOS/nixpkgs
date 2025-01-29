{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "impl";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
    hash = "sha256-0TSyg7YEPur+h0tkDxI3twr2PzT7tmo3shKgmSSJ6qk=";
  };

  vendorHash = "sha256-vTqDoM/LK5SHkayLKYig+tCrXLelOoILmQGCxlTWHog=";

  meta = with lib; {
    description = "Generate method stubs for implementing an interface";
    mainProgram = "impl";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
