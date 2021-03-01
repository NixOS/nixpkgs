{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JvHuOMpt62tw7ewDev7unAgZGV+ZSo6wDuiPhWap2v0=";
  };

  vendorSha256 = "sha256-0nnrH3GJhd4wlRETo9iSlFkXq358m30k7Fsb5haHlpQ=";
  runVend = true;

  # Tests are trying to access /homeless-shelter
  doCheck = false;

  subPackages = [ "cmd/glab" ];

  meta = with lib; {
    description = "An open-source GitLab command line tool";
    license = licenses.mit;
    homepage = "https://glab.readthedocs.io/";
    maintainers = with maintainers; [ freezeboy ];
  };
}
