{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.04";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = "git-subtrac";
    rev = "v${version}";
    hash = "sha256-3Z1AbPPsTBa3rqfvNAMBz7CIRq/zc9q5/TcLJWYSNlw=";
  };

  vendorHash = "sha256-3mJoSsGE+f9hVbNctjMR7WmSkCaHmKIO125LWG1+xFQ=";

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "git-subtrac";
  };
}
