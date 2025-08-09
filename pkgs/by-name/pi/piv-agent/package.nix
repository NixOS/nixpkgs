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
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = "piv-agent";
    rev = "v${version}";
    hash = "sha256-4oyIUE7Yy0KUw5pC64MRKeUziy+tqvl/zFVySffxfBs=";
  };

  vendorHash = "sha256-4yfQQxMf00263OKEXTWD34YifK7oDclvPk8JDz5N1I0=";

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
