{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "senv";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "SpectralOps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TjlIX8FPNiPDQo41pIt04cki/orc+v30pV3o2bQQhAQ=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-n/fzcmhHnlp/UAwpNizyP3W/o/kHvfOc+jOMm57lWeU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Friends don't let friends leak secrets on their terminal window";
    homepage = "https://github.com/SpectralOps/senv";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
