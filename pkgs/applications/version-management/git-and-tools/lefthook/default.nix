{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "0.7.6";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-qCj6FsbzxnMISCITKFcIIYtqMiHzSNYNjlpgpE9S/Ss=";
  };

  vendorSha256 = "sha256-Rp67FnFU27u85t02MIs7wZQoOa8oGsHVVPQ9OdIyTJg=";

  doCheck = false;

  meta = with lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
