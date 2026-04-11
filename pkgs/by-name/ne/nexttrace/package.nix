{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "nexttrace";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EKsOPE5EGkUtgNIf60ojvMJfZwtSwDzVDDEeKPBLWhY=";
  };
  vendorHash = "sha256-fUM2mWbol1lM6moygeCFiGHyYZfaVzz6edZM6zoGrSg=";

  buildInputs = [ libpcap ];

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nxtrace/NTrace-core/config.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/NTrace-core $out/bin/nexttrace
  '';

  meta = {
    description = "Open source visual route tracking CLI tool";
    homepage = "https://www.nxtrace.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sharzy ];
    mainProgram = "nexttrace";
  };
})
