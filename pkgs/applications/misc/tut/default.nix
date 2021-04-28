{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "0g4kbprsdjk2lbx81azdvz8kkhyk370id3622xxssr894v0i7iwj";
  };

  vendorSha256 = "1kf7ynmxrzvhl028b4nbz9h9v9x5srarsbynpgpp4vicmxqlvrmh";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
