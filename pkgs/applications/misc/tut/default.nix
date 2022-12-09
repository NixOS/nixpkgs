{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-UkgZOBNEeeYkcdp8beePrFmFLa7UWGbQ4dynl8QwnK8=";
  };

  vendorSha256 = "sha256-af+uO3NEkMt+aZoOa8NWccgtLD0Kggr2ZZwfIxoP3EU=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
