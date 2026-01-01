{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gobgp";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "3.37.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Lm0nJfvXGoRBu6Yv698zf74/xOfG7UagzvTExK6KXbo=";
  };

  vendorHash = "sha256-y8nhrKQnTXfnDDyr/xZd5b9ccXaM85rd8RKHtoDBuwI=";
=======
    sha256 = "sha256-Nh4JmyZHrT7uPi9+CbmS3h6ezKoicCvEByUJVULMac4=";
  };

  vendorHash = "sha256-HpATJztX31mNWkpeDqOE4rTzhCk3c7E1PtZnKW8Axyo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

<<<<<<< HEAD
  meta = {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
=======
  meta = with lib; {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gobgp";
  };
}
