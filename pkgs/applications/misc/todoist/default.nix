{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-lnx02fFzf8oaJ9T7MV+Gx4EpA4h7TVJK91o9+GU/Yvs=";
  };

  vendorSha256 = "sha256-ly+OcRo8tGeNX4FnqNVaqjPx/A1FALOnScxs04lIOiU=";

  doCheck = false;

  postPatch = ''
    substituteInPlace main.go --replace '0.15.0' '${version}'
  '';

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
