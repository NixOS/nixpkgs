{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "local-content-share";
  version = "31";

  src = fetchFromGitHub {
    owner = "Tanq16";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-BVO804Ndjbg4uEE1bufZcGZxEVdraV29LJ6yBWXTakA=";
  };

  vendorHash = null;

  doCheck = false;

  meta = {
    description = "Storing/sharing text/files in your local network with no setup on client devices";
    homepage = "https://github.com/Tanq16/local-content-share";
    license = lib.licenses.mit;
    mainProgram = "local-content-share";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
  };
})
