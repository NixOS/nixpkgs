{ lib, buildGoModule, fetchFromGitHub, makeWrapper, terraform }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.25.5";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "19rsnhws4cvssxjmm22j746jck0wzrhwi24hnlwxkdaaw92yd36l";
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
