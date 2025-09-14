{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
}:

buildGoModule rec {
  pname = "piv-agent";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${version}";
    hash = "sha256-NNgDkdsEN2LxgxTlH4rMkod2E0/BDkjcS8Pes2/ZFEs=";
  };

  vendorHash = "sha256-k1PMHUGu3I8tLFeeHjV2ZO9R/sHbbPzNa5u/HxzdlYc=";

  subPackages = [ "cmd/piv-agent" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.shortCommit=${src.rev}"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pcsclite ];

  meta = with lib; {
    description = "SSH and GPG agent which you can use with your PIV hardware security device (e.g. a Yubikey)";
    homepage = "https://github.com/smlx/piv-agent";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "piv-agent";
  };
}
