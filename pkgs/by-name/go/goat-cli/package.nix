{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchpatch,
}:

buildGoModule rec {
  pname = "goat-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    repo = "goat";
    owner = "studio-b12";
    rev = "v${version}";
    hash = "sha256-g5iS0XCRv97uX45BMqyFNodjjZ3Q9OeMJXAdsPwLCEg=";
  };

  vendorHash = "sha256-MOsxM8CSjK5j/guEwRFWHZ4+gdAHa5txVXw67jzwyLQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/studio-b12/goat/internal/version.Version=${version}"
    "-X github.com/studio-b12/goat/internal/version.CommitHash=${src.rev}"
  ];

  patches = [
    ./mock-fix.patch
  ];

  # Checks currently fail because of an issue with github.com/studio-b12/goat/mocks
  doCheck = false;

  meta = {
    description = "Integration testing tool for HTTP APIs using a simple script language";
    homepage = "https://studio-b12.github.io/goat/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "goat";
  };

}
