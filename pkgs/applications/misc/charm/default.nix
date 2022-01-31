{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-5WNkD+YfmQHGAWWfD9/ZEHnHPT0Ejm9Nz+/mn8xvU4U=";
  };

  vendorSha256 = "sha256-r0mYrtWllKOvKQJmW0ie4l+1nsCwU8O+CV6ESXNoETk=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
