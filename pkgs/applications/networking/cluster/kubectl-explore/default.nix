{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-4WxvVsA05Mta7AcrGe26B+Up+x/gwdlCnb/PN9Ehu18=";
  };

  vendorHash = "sha256-z/bPfY9UVqOnrA9jNUtM7jg53/URAMAJQAqH9D5KVPQ=";
  doCheck = false;

  meta = with lib; {
    description = "A better kubectl explain with the fuzzy finder";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.koralowiec ];
  };
}
