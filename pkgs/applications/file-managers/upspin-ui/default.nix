{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "upspin-ui";
  version = "2021-07-01";

  src = fetchFromGitHub {
    owner = "upspin";
    repo = "augie";
    rev = "798945a1f13394a5ab2d79bfdf1a68d87b797151";
    sha256 = "sha256-lDmYb2C5dSrjFYcEEp/PK1J3rq6LVGlOGQM242tD+4M=";
  };

  vendorSha256 = "sha256-JARX6yptKvYddli8Kw0PZd627nKiNyrTtXqnAR6o6rE=";

  # No upstream tests
  doCheck = false;

  meta = with lib; {
    description = "upspin-ui presents a web interface to the Upspin name space, and also provides a facility to sign up an Upspin user and deploy an upspinserver to Google Cloud Platform";
    homepage = "https://upspin.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orthros ];
    platforms = platforms.linux;
    mainProgram = "upspin-ui";
  };
}
