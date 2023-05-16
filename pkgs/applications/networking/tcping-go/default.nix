{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "tcping-go";
  version = "unstable-2022-05-28";

  src = fetchFromGitHub {
    owner = "cloverstd";
    repo = "tcping";
    rev = "83f644c761819f7c4386f0645cd0a337eccfc62e";
    sha256 = "sha256-GSkNfaGMJbBqDg8DKhDtLAuUg1yF3FbBdxcf4oG50rI=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-Q+aFgi7GCAn3AxDuGtRG4DdPhI7gQKEo7A9iu1YcTsQ=";
=======
  vendorSha256 = "sha256-Q+aFgi7GCAn3AxDuGtRG4DdPhI7gQKEo7A9iu1YcTsQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Ping over TCP instead of ICMP, written in Go";
    homepage = "https://github.com/cloverstd/tcping";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
