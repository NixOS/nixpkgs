{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-i8q9L8x9LNodL3ilFK5kiq744yclRfsexxS7E0i9JSo=";
  };

  vendorHash = "sha256-fWFFWFVnLtZivlqMRIi6TjvticiKlyXF2Bx9Munos8M=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
