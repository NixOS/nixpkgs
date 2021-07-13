{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ahP5y5i0SMj2+mP4RYc7MLZGElX5eLgKwiVhBYGOX2g=";
  };

  vendorSha256 = "sha256-ssVmqcJ/DxUqAkHm9tn4RwWuKzTHvxoqJquXPIRy4b8=";
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
