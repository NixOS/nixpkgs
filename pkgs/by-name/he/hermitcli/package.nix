{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hermit";
<<<<<<< HEAD
  version = "0.47.0";
=======
  version = "0.46.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
<<<<<<< HEAD
    hash = "sha256-VAAdsZ3ZFY+BrH5KDERngxX5xp8CckcnlpSLq4XWU2s=";
  };

  vendorHash = "sha256-KEwbADLm7oTChoLyx/0SykQX1Fy4bJxNbYcGmfEka7Q=";
=======
    hash = "sha256-4SOwOO9ee7fKrby9sokWW/GPujT9/O+9emcaLIe+0C0=";
  };

  vendorHash = "sha256-bko9N3dbxe4K98BdG78lYYipAgAtGntrEAgoLeOY1NM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cbrewster ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = licenses.asl20;
    maintainers = with maintainers; [ cbrewster ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hermit";
  };
}
