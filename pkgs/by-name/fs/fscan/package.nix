{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfzFBOIsuwcfmmyZMPhgP9Oznec+rJs16IuIG7gwZhA=";
  };

  vendorHash = "sha256-ihaGbm4iLjwvTzM278wuwom8LrmHB3WgmbfcJxtkbYc=";

  subPackages = [ "." ];

  meta = {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
})
