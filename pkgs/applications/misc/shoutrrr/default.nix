{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "0.8.0";
in

buildGoModule {
  pname = "shoutrrr";
  inherit version;

  src = fetchFromGitHub {
    owner = "containrrr";
    repo = "shoutrrr";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DGyFo2oRZ39r1awqh5AXjOL2VShABarFbOMIcEXlWq4=";
  };

  vendorHash = "sha256-+LDA3Q6OSxHwKYoO5gtNUryB9EbLe2jJtUbLXnA2Lug=";

  meta = with lib; {
    description = "Notification library for gophers and their furry friends";
    homepage = "https://github.com/containrrr/shoutrrr";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "shoutrrr";
  };
}
