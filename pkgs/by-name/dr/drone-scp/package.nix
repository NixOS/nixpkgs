{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "drone-scp";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wfpJXGF+bSXdQzRY13idWO8mU6SYYubtH7GtUKZzfME=";
  };

  vendorHash = "sha256-BVY6USDRSrfvozW4qmbcVW/MZuUp7Xf0sI3K90v2bRw=";

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
