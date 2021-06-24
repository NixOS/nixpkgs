{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "0qq8x37p7yxhcp5d5xss3pv5186xgg0hd6lbkqivhy5yjsd54c7b";
  };

  vendorSha256 = "1pa75rjns1kknl2gmfprdzc3f2z8dk44jkz6dmf8f3prj0z7x88c";

  doCheck = false;

  meta = with lib; {
    description = "A Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/juruen/rmapi";
    changelog = "https://github.com/juruen/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3;
    maintainers = [ maintainers.nickhu ];
  };
}
