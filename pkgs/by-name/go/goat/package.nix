{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "goat";
  version = "unstable-2022-08-15"; # Upstream currently isn't doing tags/releases.

  src = fetchFromGitHub {
    owner = "blampe";
    repo = "goat";
    rev = "07bb911fe3106cc3c1d1097318a9fffe816b59fe";
    hash = "sha256-gSSDp9Q2hGH85dkE7RoER5ig+Cz1oSOD0FNRBeTZM4U=";
  };

  vendorHash = "sha256-24YllmSUzRcqWbJ8NLyhsJaoGG2+yE8/eXX6teJ1nV8=";

  meta = with lib; {
    description = "Go ASCII Tool. Render ASCII art as SVG diagrams";
    homepage = "https://github.com/blampe/goat";
    license = licenses.mit;
    maintainers = with maintainers; [ katexochen ];
    mainProgram = "goat";
    platforms = platforms.unix;
  };
}
