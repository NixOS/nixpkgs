{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssh-chat";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "ssh-chat";
    rev = "v${version}";
    hash = "sha256-LgrqIuM/tLC0JqDai2TLu6G/edZ5Q7WFXjX5bzc0Bcc=";
  };

  vendorHash = "sha256-QTUBorUAsWDOpNP3E/Y6ht7ZXZViWBbrMPtLl7lHtgE=";

  meta = with lib; {
    description = "Chat over SSH";
    mainProgram = "ssh-chat";
    homepage = "https://github.com/shazow/ssh-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
  };
}
