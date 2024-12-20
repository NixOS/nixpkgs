{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CuxBfR+q+2JCe7F1gruGrVM+UBkrmz5dEyrDtFdmbhM=";
  };

  vendorHash = "sha256-ZS7xliFymXTE8hlc3GEMNonP5sJTZGirw5YQNzPCl3Y=";

  sourceRoot = "${src.name}/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    mainProgram = "jwx";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [
      arianvp
      flokli
    ];
  };
}
