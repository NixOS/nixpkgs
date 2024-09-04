{ lib, stdenv, buildGoModule, fetchFromGitHub, pkg-config, pcsclite }:

buildGoModule rec {
  pname = "keycard-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = pname;
    rev = version;
    hash = "sha256-K2XxajprpPjfIs8rrnf2coIEQjPnir9/U0fTvqV2++g=";
  };

  vendorHash = "sha256-3XzWOiZF2WNs2pdumYN9bphvBKY+rrjuT+wWhB2pwT0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcsclite ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Command line tool and shell to manage keycards";
    mainProgram = "keycard-cli";
    homepage = "https://keycard.status.im";
    license = licenses.mpl20;
    maintainers = [ maintainers.zimbatm ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/keycard-cli.x86_64-darwin
  };
}
