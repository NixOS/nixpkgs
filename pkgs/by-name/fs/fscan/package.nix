{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xc6SNmVPxBxcY7PH27562soejIrMXQtb09Djd0gONCo=";
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
