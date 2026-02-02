{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pelican-wings";
  version = "1.0.0-beta22";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    rev = "v${version}";
    hash = "sha256-CVH3oiqDa/kLEstvLwO45/jetKI/V1wlrXK1C+CVzgs=";
  };

  vendorHash = "sha256-Nkz9qz8rh+1dO9lGrTLLO0mOXLtcQmxi1R1jGxWiKic=";

  meta = {
    description = "Wings is Pelican's server control plane, built for the rapidly changing gaming industry and designed to be highly performant and secure.";
    homepage = "https://github.com/pelican-dev/wings";
    changelog = "https://github.com/pelican-dev/wings/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timoschirmer ];
    mainProgram = "wings";
  };
}
