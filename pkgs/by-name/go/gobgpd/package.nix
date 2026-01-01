{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gobgpd";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "3.37.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Lm0nJfvXGoRBu6Yv698zf74/xOfG7UagzvTExK6KXbo=";
  };

  vendorHash = "sha256-y8nhrKQnTXfnDDyr/xZd5b9ccXaM85rd8RKHtoDBuwI=";
=======
    hash = "sha256-Nh4JmyZHrT7uPi9+CbmS3h6ezKoicCvEByUJVULMac4=";
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

  subPackages = [
    "cmd/gobgpd"
  ];

  passthru.tests = { inherit (nixosTests) gobgpd; };

  meta = {
    description = "BGP implemented in Go";
    mainProgram = "gobgpd";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
  };
}
