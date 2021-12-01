{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-KFoaZ0OAqwJm4tEUaEAGJ+70nHJUbxg0kvhm71mQB6E=";
  };

  vendorSha256 = "sha256-gu+BU2tL/xZ7D6lZ1ueO/9IB9H3NNm4mloCZaGqZskU=";

  doCheck = false;

  meta = with lib; {
    description = "A Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/juruen/rmapi";
    changelog = "https://github.com/juruen/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.nickhu ];
  };
}
