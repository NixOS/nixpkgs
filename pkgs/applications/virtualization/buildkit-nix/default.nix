{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit-nix";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k9YO4KFIDebfszhKG6RYDFlVfbUPFHRsHRQXXlJ6SoU=";
  };

  vendorSha256 = "sha256-c+VHt2uTaEQIXsmJ9TA7X5lfMxGL9yKbbnnXn4drCLU=";

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
