{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "uni";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ij/jUbXl3GkeNZmGJ82i++6VkOW46YFI9m83otY6M7Q=";
  };

  vendorHash = "sha256-88SSrGvZSs6Opi3IKSNNqptuOWMmtTQ4ZDR7ViuGugk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    changelog = "https://github.com/arp242/uni/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
  };
}
