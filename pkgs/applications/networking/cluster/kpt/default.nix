{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "kpt";
  version = "0.39.3";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vidrKfmP0Lw6EYYufLDxh3ROOJ3hPIusDTI/Hr73NYM=";
  };

  vendorHash = "sha256-CoXlUX9hkP8gijA/vg19AS9030w95A2oKGD1wjzO8ak=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "Toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    mainProgram = "kpt";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    broken = stdenv.isDarwin;
  };
}
