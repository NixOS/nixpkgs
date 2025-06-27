{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "local-content-share";
  version = "31";

  src = fetchFromGitHub {
    owner = "Tanq16";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BVO804Ndjbg4uEE1bufZcGZxEVdraV29LJ6yBWXTakA=";
  };

  vendorHash = null;

  doCheck = false;

  meta = {
    description = "SELF-HOSTED APP FOR STORING/SHARING TEXT/FILES IN YOUR LOCAL NETWORK WITH NO SETUP ON CLIENT DEVICES";
    homepage = "https://github.com/Tanq16/${pname}";
    license = lib.licenses.mit;
    mainProgram = "local-content-share";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
  };
}
