{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.19";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-HXWE6688jhRQQEiZuPfuJStSQeueqoWwwa+PfneHprw=";
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
