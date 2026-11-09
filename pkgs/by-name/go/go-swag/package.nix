{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-swag";
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ixeHj+bqskQJOCxnJaU0IG9Qoe4SQk+McNY0Sy1tUwI=";
  };

  vendorHash = "sha256-P3WH4SrGL4Ejn4U34EEJA21Fne/UlOWg8jiI94Bp7Ms=";

  subPackages = [ "cmd/swag" ];

  meta = {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
})
