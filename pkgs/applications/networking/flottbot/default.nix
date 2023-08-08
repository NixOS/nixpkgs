{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, nixosTests
}:
buildGoModule rec {
  pname = "flottbot";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    rev = version;
    sha256 = "538c2SkyOYmm84yM0svbPeJtSIMHRI6mot8MIP5wBfc=";
  };

  vendorSha256 = "sha256-6j1nQBlFqd78v/CNV7ivwYZ5CEzGh+An6xcQr4dAkAs=";

  subPackages = [ ];

  doCheck = false; # Tries to do some networking :(

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "flottbot-([0-9.]+)" ];
    };
  };

  meta = with lib; {
    description = "A chatbot framework written in Go";
    homepage = "https://github.com/target/flottbot";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanhonof ];
  };
}
