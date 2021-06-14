{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-checkly";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "checkly";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wv7zdzzg8cjcz5h8vvnaznnbp8r7kbdc9hj10s8dmnmqkf9rf83";
  };

  vendorSha256 = "1k4rpin0ijs31hlfcrgyz97yll89ff6lbnkkscyfiw61xcsz6mhm";

  postInstall = ''
    mv $out/bin/terraform-provider-checkly{,_v${version}}
  '';

  meta = with lib; {
    homepage = "https://github.com/checkly/terraform-provider-checkly";
    description = "Terraform provider for Checkly";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
