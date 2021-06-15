{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-ju54JSd3Zyye5YGLPEOkhY93ONh0b7eDSnvJlIawizE=";
  };

  vendorSha256 = "sha256-SE/0a8QUJsWoGwkSiZqYx1eXuOIL3avJujyg8iSdcBU=";

  doCheck = false;

  meta = with lib; {
    description = "A Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/juruen/rmapi";
    changelog = "https://github.com/juruen/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.nickhu ];
  };
}
