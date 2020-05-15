{ stdenv, lib, buildGoModule, fetchFromGitHub, terraform, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.23.14";

   src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1znb9d4n9zv3dq10dw17kb1h04gj8iz6gwx1a741fcf4ygp8zpy1";
  };

  vendorSha256 = "0h737h25f80zfx84vm6ry0581c32ylcb5h9givqk5k5kh5qgkbgx";

  buildInputs = [ makeWrapper ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

  postInstall = ''
    wrapProgram $out/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform.full}/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices.";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}