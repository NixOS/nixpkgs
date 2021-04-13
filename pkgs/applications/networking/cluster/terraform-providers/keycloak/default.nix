{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "terraform-provider-keycloak";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mrparkers";
    repo = "terraform-provider-keycloak";
    rev = version;
    sha256 = "1q9vzmj9c7mznv6al58d3rs5kk1fh28k1qccx46hcbk82z52da3a";
  };

  vendorSha256 = "0kh6lljvqd577s19gx0fmfsmx9wm3ikla3jz16lbwwb8ahbqcw1f";

  doCheck = false;

  postInstall = "mv $out/bin/terraform-provider-keycloak{,_v${version}}";

  meta = with lib; {
    description = "Terraform provider for keycloak";
    homepage = "https://github.com/mrparkers/terraform-provider-keycloak";
    license = licenses.mpl20;
    maintainers = with maintainers; [ eonpatapon ];
  };

}
