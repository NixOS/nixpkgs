{ lib
, stdenv
, buildGoModule
, darwin
, fetchFromGitHub
, pcsclite
, pkg-config
}:

buildGoModule rec {
  pname = "piv-agent";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${version}";
    hash = "sha256-aukcnubhB8kbAl22eeFKzLPvVcYdgcEQ1gy3n6KWG00=";
  };

  vendorHash = "sha256-1d6EKEvo4XNDXRtbdnKkqyF9y0LPPHWKu9X/wYnbmas=";

  subPackages = [ "cmd/piv-agent" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.shortCommit=${src.rev}" ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs =
    if stdenv.isDarwin
    then [ darwin.apple_sdk.frameworks.PCSC ]
    else [ pcsclite ];

  meta = with lib; {
    description = "SSH and GPG agent which you can use with your PIV hardware security device (e.g. a Yubikey)";
    homepage = "https://github.com/smlx/piv-agent";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "piv-agent";
  };
}
