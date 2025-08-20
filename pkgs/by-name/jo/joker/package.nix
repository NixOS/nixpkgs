{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "joker";
  version = "1.5.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-pXeYVhm8lpwzn1IAwYquBMmuQsbAev06BzK4TvtNsLo=";
  };

  vendorHash = "sha256-yH8QVzliAFZlOvprfdh/ClCWK2/7F96f0yLWvuAhGY8=";

  doCheck = false;

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/candid82/joker";
    description = "Small Clojure interpreter and linter written in Go";
    mainProgram = "joker";
    license = licenses.epl10;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
