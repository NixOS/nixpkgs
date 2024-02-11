{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sesh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "be2badd29206f66803b76b62b23f6f5e05befe08";
    sha256 = "sha256-8gn4YdKHurPbPuJ+AeCB7x9IDxTtHGpYUZCKlSdujcs=";
  };

  vendorHash = "sha256-zt1/gE4bVj+3yr9n0kT2FMYMEmiooy3k1lQ77rN6sTk=";

  meta = with lib; {
    description = "Smart session manager for the terminal.";
    homepage = "https://github.com/joshmedeski/sesh";
    license = licenses.mit;
    maintainers = with maintainers; [ Meliketoaste ];
  };

}
