{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gore";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "gore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EPySMj+mQxTJbGheAtzKvQq23DLljPR6COrmytu1x/Q=";
  };

  vendorHash = "sha256-W9hMxANySY31X2USbs4o5HssxQfK/ihJ+vCQ/PTyTDc=";

  doCheck = false;

  meta = {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
