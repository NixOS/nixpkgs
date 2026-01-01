{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postfix-tlspol";
<<<<<<< HEAD
  version = "1.8.24";
=======
  version = "1.8.22";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Zuplu";
    repo = "postfix-tlspol";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uWtpNdI4rbNEc3Ix0KMxwKEHtpDR7Atshut1DmPLxxc=";
=======
    hash = "sha256-mE6vcXAmlJZSV4q4van4/PeiAadw50OXC6NujrLH4p4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  # don't run tests, they perform checks via the network
  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  passthru.tests = {
    inherit (nixosTests) postfix-tlspol;
  };

  meta = {
    changelog = "https://github.com/Zuplu/postfix-tlspol/releases/tag/${src.tag}";
    description = "Lightweight MTA-STS + DANE/TLSA resolver and TLS policy server for Postfix, prioritizing DANE";
    homepage = "https://github.com/Zuplu/postfix-tlspol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      valodim
    ];
    mainProgram = "postfix-tlspol";
    platforms = lib.platforms.linux;
  };
}
