{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
<<<<<<< HEAD
  version = "3.23.4";
=======
  version = "3.23.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7+hOXJU2a39ytn08FlR/YAhOnAmVL5JxdcvF1AlOxHk=";
  };
  vendorHash = "sha256-VSjiEgkjLMFRThNI4G7O91wpF8CYaIVYOrtE49S/o3w=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
=======
    hash = "sha256-jmEpFbWCIPhSQWlO047buoltFdGhZCF+IxJmwAxedpo=";
  };
  vendorHash = "sha256-2H5VtNZiOnx1gFSVaBu7q4HTeLhBbIDK01fixBB66M4=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
