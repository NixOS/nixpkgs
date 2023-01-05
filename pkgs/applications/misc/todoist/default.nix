{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-46wNacsK2kGHaq2MgcW4ELI2TIY+4leraGQwU4V7sVo=";
  };

  vendorSha256 = "sha256-ly+OcRo8tGeNX4FnqNVaqjPx/A1FALOnScxs04lIOiU=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
