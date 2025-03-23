{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "poptop";
  version = "0.1.8";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bakks";
    repo = "poptop";
    rev = "v${version}";
    hash = "sha256-CwJpkGNTDmtXfJx6GGz2XRU0fMeKl7I3fXm4BJ9MAQ4=";
  };

  vendorHash = "sha256-Ccvr+J+GDKnhlrlv0/kTaQYD986As7yb/h6Vyiuqjoc=";

  meta = {
    description = "Modern top command that charts system metrics like CPU load, network IO, etc in the terminal";
    changelog = "https://github.com/bakks/poptop/releases/tag/v${version}";
    homepage = "https://github.com/bakks/poptop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "poptop";
  };
}
