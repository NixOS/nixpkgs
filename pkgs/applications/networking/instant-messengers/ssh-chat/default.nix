{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssh-chat";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "ssh-chat";
    rev = "v${version}";
    sha256 = "LgrqIuM/tLC0JqDai2TLu6G/edZ5Q7WFXjX5bzc0Bcc=";
  };

  vendorSha256 = "QTUBorUAsWDOpNP3E/Y6ht7ZXZViWBbrMPtLl7lHtgE=";

  meta = with lib; {
    description = "Chat over SSH";
    homepage = "https://github.com/shazow/ssh-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
  };
}
