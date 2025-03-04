{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-swag";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-wqBT7uan5XL51HHDGINRH9NTb1tybF44d/rWRxl6Lak=";
  };

  vendorHash = "sha256-6L5LzXtYjrA/YKmNEC/9dyiHpY/8gkH/CvW0JTo+Bwc=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
