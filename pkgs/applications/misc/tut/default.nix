{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-8aa3LYLHjodyYradF2NBuZReHTYBf9TvfVCoDs0gAUw=";
  };

  vendorSha256 = "sha256-DcMsxqUO9H1q5+njoOuxQ6l8ifSFuS1jdWSvY/5MDm8=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
