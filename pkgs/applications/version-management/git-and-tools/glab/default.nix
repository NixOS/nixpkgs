{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wOeWqgN0VYmTXPTU3z5Utau8diW18QKV7w/2y86R8U0=";
  };

  vendorSha256 = "sha256-Ge3nwI0cY2JxRTn3EZtlal5c6A6TIKfH/CkJnQ1C6PY=";
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
