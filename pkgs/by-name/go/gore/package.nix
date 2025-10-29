{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gore";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "gore";
    rev = "v${version}";
    sha256 = "sha256-EPySMj+mQxTJbGheAtzKvQq23DLljPR6COrmytu1x/Q=";
  };

  vendorHash = "sha256-W9hMxANySY31X2USbs4o5HssxQfK/ihJ+vCQ/PTyTDc=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
