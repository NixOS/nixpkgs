{
  lib,
  stdenv,
  buildGoModule,
  darwin,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
}:

buildGoModule rec {
  pname = "piv-agent";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${version}";
    hash = "sha256-bfJIrWDFQIg0n1RDadARPHhQwE6i7mAMxE5GPYo4WU8=";
  };

  vendorHash = "sha256-HIB+p0yh7EWudLp1YGoClYbK3hkYEJZ+o+9BbOHE4+0=";

  subPackages = [ "cmd/piv-agent" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.shortCommit=${src.rev}"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then [ darwin.apple_sdk.frameworks.PCSC ] else [ pcsclite ];

  meta = with lib; {
    description = "SSH and GPG agent which you can use with your PIV hardware security device (e.g. a Yubikey)";
    homepage = "https://github.com/smlx/piv-agent";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "piv-agent";
  };
}
