{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitea,
  nixosTests,
}:

buildGoModule rec {
  pname = "eris-go";
  version = "20240826";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "eris-go";
    rev = version;
    hash = "sha256-qw3HdHtyMuWqwkuGzVzQ8bXnXlJJPDpiYrQZb0lIYj8=";
  };

  vendorHash = "sha256-TnB4BSO2Yb9AtcHgdEgNrFHAQJ7u4IzmhLdcSjbZ7SA=";

  postInstall = ''
    install -D *.1.gz -t $man/share/man/man1
  '';

  env.skipNetworkTests = true;

  passthru.tests = { inherit (nixosTests) eris-server; };

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    homepage = "https://codeberg.org/eris/eris-go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eris-go";
  };
}
