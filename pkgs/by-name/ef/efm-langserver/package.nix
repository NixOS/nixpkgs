{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.54";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-3ZrWc8/4aC5TOoL9vybkMZC9HkIL43TokebFcJYyrcI=";
  };

  vendorHash = "sha256-FOAKxKqhrUpfXkoasSd7v3kKAqV11p5ieZaMPni5Hx4=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    mainProgram = "efm-langserver";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
