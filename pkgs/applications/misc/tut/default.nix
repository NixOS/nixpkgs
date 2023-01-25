{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-Oypl80UsYRRSIMvHDPSS6rrvzjlxZ/UKDNDGc2Yan+w=";
  };

  vendorHash = "sha256-qeYgkF9sIJ0slRarXbCHZ+1JmtZwXDnrJIpRKGOoW5Q=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
