{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "harsh";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yOF+SZaUOkZnU0uYrsvClpPvKO64cFFB9qmOPoh6ZcA=";
  };

  vendorHash = "sha256-hdPkiF1HHuIl6KbilPre6tAqSnYPhYhrxBEj3Ayy2AY=";

  meta = with lib; {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "harsh";
  };
}
