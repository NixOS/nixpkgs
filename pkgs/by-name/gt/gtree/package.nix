{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gtree,
}:

buildGoModule rec {
  pname = "gtree";
<<<<<<< HEAD
  version = "1.13.2";
=======
  version = "1.13.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CTAUyFkIKk2WnZWVtIG6tZfjNT445DBDgeh5gTb4q6k=";
  };

  vendorHash = "sha256-LWsJWh7LYkB5IWJaNJsy+K2xYNiw4mGy/YGT42at5C0=";
=======
    hash = "sha256-+Prv0TtyqE02DHbYwooy8OWQn4C82Lyfikd+l0YEHZc=";
  };

  vendorHash = "sha256-0St9T9xJ8lOZgBUtwfzrHqSpcv6SAoxy4PNBBuuNO+A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/gtree"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gtree;
    };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Generate directory trees and directories using Markdown or programmatically";
    mainProgram = "gtree";
    homepage = "https://github.com/ddddddO/gtree";
    changelog = "https://github.com/ddddddO/gtree/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
=======
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
