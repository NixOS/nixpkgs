{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghr";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-pF1TPvQLPa5BbXZ9rRCq7xWofXCBRa9CDgNxX/kaTMo=";
  };

  vendorSha256 = "sha256-+e9Q4Pw9pJyOXVz85KhOSuybj1PBcJi51fGR3a2Gixk=";

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
