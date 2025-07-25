{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-swag";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-7JnXJ6hx03BBSD1DzO5zrzhlcWOdSQb6GHlXO5bA3Ac=";
  };

  vendorHash = "sha256-P3WH4SrGL4Ejn4U34EEJA21Fne/UlOWg8jiI94Bp7Ms=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
