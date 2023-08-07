{ lib, buildGoModule, fetchFromGitHub, nixosTests, nix-update-script }:
buildGoModule rec {
  pname = "flottbot";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    rev = version;
    sha256 = "ykT719DOgDH+uFyrIF8UNQQwWbf6SkDmEMsjwjjAouQ=";
  };

  vendorSha256 = "sha256-HbijD5P7ttfek9gFQwXq50cI2rQ1MN3CzRmIk8mLW1g=";

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
    platforms = platforms.unix;
  };
}
