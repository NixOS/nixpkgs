{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchpatch
}:

buildNpmPackage rec {
  pname = "mathjax-node-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mathjax";
    repo = "mathjax-node-cli";
    rev = version;
    hash = "sha256-jFSn/Ftm1iNOAmMadHYfy2jm0H/+hP2XCyyNbJqfhkY=";
  };

  patches = [
    # https://github.com/mathjax/mathjax-node-cli/pull/20
    (fetchpatch {
      name = "add-package-lock.patch";
      url = "https://github.com/mathjax/mathjax-node-cli/commit/ac304d896d840dc5004045f012abab40648d20fd.patch";
      hash = "sha256-kIfxF5II/PHtzBhhMbO2RcEuZQCNFrLeAnL536WBXq8=";
    })
  ];

  npmDepsHash = "sha256-gGTRr8CN6aP/T/jUqt4E53DYVaz7ykaoG519+3sPdXo=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tools for mathjax-node";
    homepage = "https://github.com/mathjax/mathjax-node-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colinsane ];
  };
}
