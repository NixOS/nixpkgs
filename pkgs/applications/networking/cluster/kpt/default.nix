{ buildGoModule, fetchFromGitHub, lib, updateGolangSysHook }:

buildGoModule rec {
  pname = "kpt";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PG4SzycXRguKyaQ7LDnTtxF3EgqcjfjeEWD5rROXBPI=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-YViBjumSGOa7lRuKuZBUWJPa62U5eSi+mXtZWg/4fb4=";

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
