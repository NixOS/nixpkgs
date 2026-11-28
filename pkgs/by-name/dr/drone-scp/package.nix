{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "drone-scp";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DaNHdNkjiGWz/T0zAFrhNkB1PHG64Gt85uJtWmX2lII=";
  };

  vendorHash = "sha256-x0saXXcnCFaABYpwJRSo1+l2R4EaWSowCdHd+TA71kc=";

  # Needs a specific user...
  doCheck = false;

  meta = {
    description = "Copy files and artifacts via SSH using a binary, docker or Drone CI";
    homepage = "https://github.com/appleboy/drone-scp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "drone-scp";
  };
})
