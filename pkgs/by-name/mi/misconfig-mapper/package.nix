{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
<<<<<<< HEAD
  version = "1.14.16";
=======
  version = "1.14.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/i1LElC2Yl8dzVOg0OX0CHR1d/01/nK9RVPsKzNvl9o=";
  };

  vendorHash = "sha256-N9fBmBBq18D+Bbag+SKGDIupGH2b4paWjFiXc1m50n4=";
=======
    hash = "sha256-5tugmwr1TyBa89a/yrch+cshyoiJ3uj4EoweltN5d/0=";
  };

  vendorHash = "sha256-pLhc3Lc8Mp5ZRmNvac3qdQcw1rPQs7bbn4K0UHp04Qs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
<<<<<<< HEAD
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
