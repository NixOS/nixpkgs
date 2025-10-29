{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  pcsclite,
}:

buildGoModule rec {
  pname = "keycard-cli";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "keycard-cli";
    rev = version;
    hash = "sha256-H9fipHGxINMAXdxUYhyVZusDXA3HW1iQl8iRX6AF7iE=";
  };

  vendorHash = "sha256-6zZY6pMazapteJp2fsCdwXBEXbwSf/ZEUIcQONJYj2Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcsclite ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Command line tool and shell to manage keycards";
    mainProgram = "keycard-cli";
    homepage = "https://keycard.status.im";
    license = licenses.mpl20;
    maintainers = [ maintainers.zimbatm ];
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/keycard-cli.x86_64-darwin
  };
}
