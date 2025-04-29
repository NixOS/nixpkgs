{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "albedo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "albedo";
    tag = "v${version}";
    hash = "sha256-Yx8C44/Dy4hlmCxpuTjhqwwvEZq6HOdvq1AeNRd17MM=";
  };

  vendorHash = "sha256-qZga699UjBsPmOUSN66BFInl8Bmk42HiVn0MfPlxRE4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "HTTP reflector and black hole";
    homepage = "https://github.com/coreruleset/albedo";
    changelog = "https://github.com/coreruleset/albedo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "albedo";
  };
}
