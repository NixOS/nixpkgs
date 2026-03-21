{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hostess";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cbednarski";
    repo = "hostess";
    rev = "v${finalAttrs.version}";
    sha256 = "1izszf60nsa6pyxx3kd8qdrz3h47ylm17r9hzh9wk37f61pmm42j";
  };

  subPackages = [ "." ];

  vendorHash = null;

  meta = {
    description = "Idempotent command-line utility for managing your /etc/hosts* file";
    mainProgram = "hostess";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edlimerkaj ];
  };
})
