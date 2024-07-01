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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${version}";
    hash = "sha256-M6klwP85Ujd/DtWh4AwCVrqk6GYqxdz0DrnKKbmdtX4=";
  };

  vendorHash = "sha256-L5HuTYA01w3LUtSy7OVxG6QN5uQZ8LVYyrBcJQTkIUA=";

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
