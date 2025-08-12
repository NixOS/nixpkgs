{
  lib,
  buildGoModule,
  fetchFromGitHub,
  jq,
  oniguruma,
}:

buildGoModule rec {
  pname = "faq";
  # Latest git release (0.0.7) presents vendor issues - using latest commit instead.
  version = "unstable-2022-01-09";

  src = fetchFromGitHub {
    owner = "jzelinskie";
    repo = "faq";
    rev = "594bb8e15dc4070300f39c168354784988646231";
    sha256 = "1lqrchj4sj16n6y5ljsp8v4xmm57gzkavbddq23dhlgkg2lfyn91";
  };
  vendorHash = "sha256-731eINkboZiuPXX/HQ4r/8ogLedKBWx1IV7BZRKwU3A";

  buildInputs = [
    jq
    oniguruma
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jzelinskie/faq/internal/version.Version=${version}"
  ];

  tags = [
    "netgo"
  ];

  subPackages = [
    "cmd/faq"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Intended to be a more flexible jq, supporting additional formats";
    mainProgram = "faq";
    homepage = "https://github.com/jzelinskie/faq";
    license = licenses.asl20;
    maintainers = with maintainers; [ quentin-m ];
  };
}
