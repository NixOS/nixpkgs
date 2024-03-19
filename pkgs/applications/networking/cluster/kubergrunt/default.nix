{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-r2lx+R/TQxD/miCJK3V//N3gKiCrg/mneT9BS+ZqRiU=";
  };

  vendorHash = "sha256-K24y41qpuyBHqljUAtNQu3H8BNqznxYOsvEVo+57OtY=";

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  postInstall = ''
    # The binary is named kubergrunt
    mv $out/bin/cmd $out/bin/kubergrunt
  '';

  meta = with lib; {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    mainProgram = "kubergrunt";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
