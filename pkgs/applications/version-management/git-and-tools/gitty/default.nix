{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gitty";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "gitty";
    rev = "v${version}";
    sha256 = "sha256-BlYZe8bLyr6QQmBwQQ0VySHohKLRVImECxfzAOPm8Xg=";
  };

  vendorSha256 = "sha256-LINOjjKicnr0T9RiOcSWWDl0bdY3c6EHHMTBA9LTOG4=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/gitty/";
    description = "Contextual information about your git projects, right on the command-line";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
