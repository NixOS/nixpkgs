{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
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

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = { inherit (nixosTests) certmgr; };

  meta = with lib; {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's automated certificate management using a CFSSL CA";
    mainProgram = "certmgr";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [
      johanot
      srhb
    ];
  };
}
