{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    hash = "sha256-mcyijASjm4DeXsh5ZPLoYuRypCeIbp2FcSIDA0M+l2g=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ git ];

<<<<<<< HEAD
  meta = {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.edef ];
=======
  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "git-codereview";
  };
}
