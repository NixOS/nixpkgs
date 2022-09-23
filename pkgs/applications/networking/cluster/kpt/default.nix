{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PG4SzycXRguKyaQ7LDnTtxF3EgqcjfjeEWD5rROXBPI=";
  };

  vendorSha256 = "sha256-CoXlUX9hkP8gijA/vg19AS9030w95A2oKGD1wjzO8ak=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
