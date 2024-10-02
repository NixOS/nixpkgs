{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pacproxy";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "williambailey";
    repo = "pacproxy";
    rev = "v${version}";
    hash = "sha256-oDSptPihrDIiTCgcP4t2J3vJBNGMViyPAAmBv4ynLNU=";
  };

  vendorHash = "sha256-0Go+xwzaT1qt+cJfcPkC8ft3eB/OZCvOi2Pnn/A/rtQ=";

  meta = with lib; {
    description = "No-frills local HTTP proxy server powered by a proxy auto-config (PAC) file";
    homepage = "https://github.com/williambailey/pacproxy";
    changelog = "https://github.com/williambailey/pacproxy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
    mainProgram = "pacproxy";
  };
}
