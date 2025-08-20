{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LU74vm36NuA1ApJWtEf/ub3los6yVR8yiQTfM0Wnvyo=";
  };

  vendorHash = "sha256-nm+KvpcOUTR9Nm0eQtqCWxMiFTvL5xKLhsPaJlsVpkQ=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
}
