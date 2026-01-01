{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddns-go";
<<<<<<< HEAD
  version = "6.14.1";
=======
  version = "6.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-c+V+EgJvElL/Ga0z6420E50c59cmjn/IlkfyeATLDFs=";
  };

  vendorHash = "sha256-vpdT1apjuMvM6MmQfx1XBQtQznK7oxUjIdkgOXjUF6g=";
=======
    hash = "sha256-Jko5cVcCMrBsfcOOSh6ETlk1jdTCbSj1zOgTwhXnxzQ=";
  };

  vendorHash = "sha256-URPCqItQ/xg8p0EdkMS6z8vuSJ1YaCicsvyb+Jvj2CU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X main.version=${version}"
  ];

  # network required
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
=======
  meta = with lib; {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = licenses.mit;
    maintainers = with maintainers; [ oluceps ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ddns-go";
  };
}
