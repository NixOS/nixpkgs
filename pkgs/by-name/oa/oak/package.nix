{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oak";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "thesephist";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DK5n8xK57CQiukyBt9+CFK1j8+nphP//T2jTXq64VH8=";
  };

  vendorHash = "sha256-iQtb3zNa57nB6x4InVPw7FCmW7XPw5yuz0OcfASXPD8=";

  meta = with lib; {
    description = "Expressive, simple, dynamic programming language";
    mainProgram = "oak";
    homepage = "https://oaklang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ tejasag ];
  };
}
