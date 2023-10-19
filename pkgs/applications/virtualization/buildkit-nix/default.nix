{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit-nix";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i8KQLLL36iP26jIj10fZLtYpS57Xni4eIQEJG4ixWy8=";
  };

  vendorHash = "sha256-SFsf2QOIuUQY5Zzshb2190pQtOBGEsELBRihOvHYVGA=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Nix frontend for BuildKit";
    homepage = "https://github.com/reproducible-containers/buildkit-nix/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lesuisse ];
  };
}
