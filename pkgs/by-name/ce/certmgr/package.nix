{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "certmgr";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "certmgr";
    rev = "v${version}";
    hash = "sha256-MgNPU06bv31tdfUnigcmct8UTVztNLXcmTg3H/J7mic=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's automated certificate management using a CFSSL CA";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ johanot srhb ];
  };
}
