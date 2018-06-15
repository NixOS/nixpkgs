{ stdenv, lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "terraform-provider-nixos-${version}";
  version = "0.0.1";
  goPackagePath = "github.com/tweag/terraform-provider-nixos";
  src = fetchFromGitHub {
    owner = "tweag";
    repo = "terraform-provider-nixos";
    sha256 = "00vz6qjq1pk39iqg4356b8g3c6slla9jifkv2knk46gc9q93q0lf";
    rev = "v${version}";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-nixos{,_v${version}}";

  meta = with stdenv.lib; {
    description = "Terraform plugin for outputting NixOS configuration files from Terraform resources.";
    homepage = "https://github.com/tweag/terraform-provider-nixos";
    license = licenses.mpl20;
    maintainers = with maintainers; [ grahamc ];
  };
}
