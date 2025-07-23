{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "hcl2json";
    rev = "v${version}";
    sha256 = "sha256-fgRrIJnl7lV3a2+d9/F141xCAKOj0WmeNlrtEwdl1qA=";
  };

  vendorHash = "sha256-qG7n8OLpCknjjTxi4ojsvz6D7JXIK5Ac9B/JS8vf9fg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
}
