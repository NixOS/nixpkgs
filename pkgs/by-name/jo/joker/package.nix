{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "joker";
  version = "1.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-FdmCNn4vfTpodpyESKd3PThqVCSJ+Mz3gfUDGDQvPCo=";
  };

  vendorHash = "sha256-4j8+NEvudeEhBkwlS7CgNhLNB7maTE46tqZeG9oqs7w=";

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
