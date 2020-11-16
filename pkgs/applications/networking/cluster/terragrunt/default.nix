{ lib, buildGoModule, fetchFromGitHub, makeWrapper, terraform }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bp43rsnkq2ysdl0v28i9agan738m0zk5yn8zza6js28sx0y7kns";
  };

  vendorSha256 = "0l85jx02dj9qvxs8l0ln5fln8vssi0fisblm5i1scz9x4a1jqg9n";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  buildFlagsArray = [ "-ldflags=" "-X main.VERSION=v${version}" ];

  postInstall = ''
    wrapProgram $out/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform.full}/bin/terraform
  '';

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg jk ];
  };
}
