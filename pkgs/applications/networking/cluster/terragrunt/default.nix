{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0414xmmx8lzv779zvr1k265c9kh3jlx9c5acg56hl5zzvifl774r";
  };

  vendorSha256 = "0l85jx02dj9qvxs8l0ln5fln8vssi0fisblm5i1scz9x4a1jqg9n";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  buildFlagsArray = [ "-ldflags=" "-X main.VERSION=v${version}" ];

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
