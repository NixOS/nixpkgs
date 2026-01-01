{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "certinfo-go";
<<<<<<< HEAD
  version = "0.1.50";
=======
  version = "0.1.47";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MR7JYhYGE0WUwsBoie8wWEWqCGdpl+k4eUWIVVS5CEg=";
  };

  vendorHash = "sha256-3GjVPV8Lwi4yNbIl/IT0fe9yFlWaqqCU1hzfR8H5r7Y=";
=======
    hash = "sha256-2/P2hg8y1Ac7ztRshsNR8S4tUy7VV7zy4XIOVDCVLtw=";
  };

  vendorHash = "sha256-pGAoQi397/ZQU/I73H9aK4gDKYoXuK5FU0RxL1+FgX8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
