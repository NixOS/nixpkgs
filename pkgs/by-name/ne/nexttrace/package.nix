{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "nexttrace";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5J0P+HlfSt6wd/q7L/+6h7auQQBJkaA1NO053w32S8Y=";
  };
  vendorHash = "sha256-9g0OZczhIhM96eYFyAMxajpIkRgNUkn6QUZtl3O/xSM=";

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
