{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x0dBiRHaDxKrTCR2RfP2/bpBo6xewu8FX7Bv4ugaUAY=";
  };

  vendorHash = "sha256-aNQuALDe37lsmTGpClIBOQJlL0NFSAZCgcmTjx0kP+U=";

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    mainProgram = "eclint";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
