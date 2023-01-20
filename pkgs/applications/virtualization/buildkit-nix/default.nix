{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit-nix";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hrrvDby+UDwY0wvq/HIP9lYVEa/flr/1gtGXHMN8Mug=";
  };

  vendorSha256 = "sha256-1H5oWgcaamf+hocABWWnzJUjWiqwk1ZZtbBjF6EKzzU=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Nix frontend for BuildKit";
    homepage = "https://github.com/AkihiroSuda/buildkit-nix/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lesuisse ];
  };
}
