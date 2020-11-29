{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "mmrTuldU2WDe9t2nC3DYfqwb28uh6qjAaaveR221mjw=";
  };

  vendorSha256 = "B4RKcKUTdGkonsKhL7NIKzVpZq6XD6cMMWed4wr/Moc=";
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
