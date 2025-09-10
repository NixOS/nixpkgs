{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "local-content-share";
  version = "35";

  src = fetchFromGitHub {
    owner = "Tanq16";
    repo = "local-content-share";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pFYkq1QqGugOVT0uMPC11ChXtxMwGv4JZKGWIqK7y3s=";
  };

  vendorHash = null;

  # no test file in upstream
  doCheck = false;

  meta = {
    description = "Storing/sharing text/files in your local network with no setup on client devices";
    homepage = "https://github.com/Tanq16/local-content-share";
    license = lib.licenses.mit;
    mainProgram = "local-content-share";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
  };
})
