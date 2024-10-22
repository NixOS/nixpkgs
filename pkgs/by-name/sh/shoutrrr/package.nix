{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.8.0";
in
buildGoModule {
  pname = "shoutrrr";
  inherit version;

  src = fetchFromGitHub {
    repo = "shoutrrr";
    owner = "containrrr";
    rev = "refs/tags/v${version}";
    hash = "sha256-DGyFo2oRZ39r1awqh5AXjOL2VShABarFbOMIcEXlWq4=";
  };

  vendorHash = "sha256-+LDA3Q6OSxHwKYoO5gtNUryB9EbLe2jJtUbLXnA2Lug=";

  meta = {
    description = "Notification library for gophers and their furry friends";
    homepage = "https://github.com/containrrr/shoutrrr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ JManch ];
    platforms = lib.platforms.unix;
    mainProgram = "shoutrrr";
  };
}
