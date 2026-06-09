{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certigo";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certigo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-U+VbtY34lxLBHWI1BjkPxzSS6q41R9DQkGvDvSDX9WY=";
  };

  vendorHash = "sha256-5DpgOb0YxZ/os23y+siCB73dUwutxXIW5RlCZqdbxao=";

  meta = {
    description = "Utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "certigo";
  };
})
