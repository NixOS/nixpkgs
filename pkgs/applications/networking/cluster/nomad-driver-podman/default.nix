{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a2alapqm7wnkjm9cg0gvi63pkaila9lhsa5razv0vprhg1k84gy";
  };

  vendorSha256 = "1zs5y0zfi8dd9w371hpmah4iwxahgvaf70biqqdw3c9yp6yw2rwq";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
