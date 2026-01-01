{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-judge";
<<<<<<< HEAD
  version = "1.11.2";
=======
  version = "1.9.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qSTtXLjtrwwp6ipnquzoDM6yzAtoE3WIAXqWFCuOI9s=";
  };

  vendorHash = "sha256-+KPbY63wF+zh7R7OVyfBI7Nuf8kAh35dxJIIRrP5Js0=";
=======
    hash = "sha256-do+CvDEyYt9Yxrpkvyk6TWYt3TMjIcxkBQ8qf4rzT/E=";
  };

  vendorHash = "sha256-XigQHewE0ehdMuYEktPSHcAZ3G1QxjoHVG616FZ9KZw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

<<<<<<< HEAD
  meta = {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = lib.licenses.mit;
    mainProgram = "go-judge";
    maintainers = with lib.maintainers; [ criyle ];
=======
  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
