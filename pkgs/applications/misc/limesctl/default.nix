{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+KOtGf+WgI2PhfFJnNyx5ycekRmfbqjSqvWOEhG65Oo=";
  };

  vendorSha256 = "sha256-LzLUz6diWva2HaxlhEGElbwUvUhCR0Tjsk/G/n5N3+k=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
