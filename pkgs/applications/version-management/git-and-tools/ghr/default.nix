{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghr";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "1nm5kdjkqayxh06j9nr5daic9sw9nx9w06y9gaqhdrw9byvjpr1a";
  };

  vendorSha256 = "14avsngzhl1b8a05i43ph6sxh9vj0jls0acxr9j7r0h3f0vpamcj";

  # Tests require a Github API token, and networking
  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/ghr --version
  '';

  meta = with lib; {
    homepage = "https://github.com/tcnksm/ghr";
    description = "Upload multiple artifacts to GitHub Release in parallel";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
  };
}
