{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-vercel";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ondrejsika";
    repo = pname;
    rev = "v${version}";
    sha256 = "06lskp3mmax7g0lchq6jaxavycj7snkhip9madzqkr552qvz5cgw";
  };

  vendorSha256 = "0s0kf1v2217q9hfmc7r2yybcfk33k566dfvs2jiq63kyjnadhb0k";

  postInstall = "mv $out/bin/terraform-provider-vercel{,_v${version}}";

  meta = with lib; {
    homepage = "https://github.com/ondrejsika/terraform-provider-vercel";
    description = "Terraform provider for Vercel";
    maintainers = with maintainers; [ mmahut ];
  };
}
