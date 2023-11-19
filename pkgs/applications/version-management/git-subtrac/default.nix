{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.04";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Z1AbPPsTBa3rqfvNAMBz7CIRq/zc9q5/TcLJWYSNlw=";
  };

  vendorHash = "sha256-3mJoSsGE+f9hVbNctjMR7WmSkCaHmKIO125LWG1+xFQ=";

  doCheck = false;

  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
