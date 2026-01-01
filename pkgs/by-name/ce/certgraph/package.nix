{
  lib,
  buildGoModule,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "certgraph";
<<<<<<< HEAD
  version = "0.1.2";
=======
  version = "20220513";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = "certgraph";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-WlNrKmny4fODnSEkP8HUF+VzMX1/LKYMdSnm7DON8Po=";
  };

  vendorHash = "sha256-4wj96eDibGB3oX56yIr01CYLZCYMFnfoaPWaNdFH7IE=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    changelog = "https://github.com/lanrat/certgraph/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "certgraph";
=======
    rev = version;
    sha256 = "sha256-7tvPiJHZE9X7I79DFNF1ZAQiaAkrtrXiD2fY7AkbWMk=";
  };

  vendorHash = "sha256-ErTn7pUCtz6ip2kL8FCe+3Rhs876xtqto+z5nZqQ6cI=";

  meta = with lib; {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    mainProgram = "certgraph";
    homepage = "https://github.com/lanrat/certgraph";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
