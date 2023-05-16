{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal, testers, gitsign }:

buildGoModule rec {
  pname = "gitsign";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-99JpuABkPHTNy9OpvRL7aIe1ZTrs2uZvxtxZf8346Ao=";
  };
  vendorHash = "sha256-+EKC/Up48EjwfVhLTpoxctWCSMDL0kLZaRPLBl0JGFQ=";
=======
    hash = "sha256-VgkTFYnHKpqZOack5SabOFu2BRespVRhgrsepo0V1mI=";
  };
  vendorHash = "sha256-zalysp+90+QM5hX7yUudJW61h+3tQOab7ZpcF5kZSB0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "."
    "cmd/gitsign-credential-cache"
  ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  passthru.tests.version = testers.testVersion { package = gitsign; };

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse developer-guy ];
  };
}
